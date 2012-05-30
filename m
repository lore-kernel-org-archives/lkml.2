Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751872Ab2E3TXH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 15:23:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931Ab2E3TXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 15:23:06 -0400
Date: Wed, 30 May 2012 16:23:14 -0300
From: Luiz Capitulino <lcapitulino@redhat.com>
To: Wen Congyang <wency@cn.fujitsu.com>
Cc: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Gleb Natapov <gleb@redhat.com>
Subject: Re: [Qemu-devel] [PATCH 3/3] deal with guest panicked event
Message-ID: <20120530162314.1e9e4d3c@doriath.home>
In-Reply-To: <4FB9E5CB.2020208@cn.fujitsu.com>
References: <4FB9E4CE.8060709@cn.fujitsu.com>
	<4FB9E5CB.2020208@cn.fujitsu.com>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2012 14:50:51 +0800
Wen Congyang <wency@cn.fujitsu.com> wrote:

> When the guest is panicked, it will write 0x1 to the port 0x505. So if
> qemu reads 0x1 from this port, we can do the folloing three things
> according to the parameter -onpanic:
> 1. emit QEVENT_GUEST_PANICKED only
> 2. emit QEVENT_GUEST_PANICKED and pause VM
> 3. emit QEVENT_GUEST_PANICKED and quit VM
> 
> Note: if we emit QEVENT_GUEST_PANICKED only, and the management
> application does not receive this event(the management may not
> run when the event is emitted), the management won't know the
> guest is panicked.

It will if it checks the vm status.

Btw, please, split this further into a patch adding the event, another one
adding the new runstate and then the rest. One more comment below.

> 
> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
> ---
>  kvm-all.c        |   84 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  kvm-stub.c       |    9 ++++++
>  kvm.h            |    3 ++
>  monitor.c        |    3 ++
>  monitor.h        |    1 +
>  qapi-schema.json |    6 +++-
>  qemu-options.hx  |   14 +++++++++
>  qmp.c            |    3 +-
>  vl.c             |   17 ++++++++++-
>  9 files changed, 137 insertions(+), 3 deletions(-)
> 
> diff --git a/kvm-all.c b/kvm-all.c
> index 9b73ccf..b5b0531 100644
> --- a/kvm-all.c
> +++ b/kvm-all.c
> @@ -19,6 +19,7 @@
>  #include <stdarg.h>
>  
>  #include <linux/kvm.h>
> +#include <linux/kvm_para.h>
>  
>  #include "qemu-common.h"
>  #include "qemu-barrier.h"
> @@ -29,6 +30,8 @@
>  #include "bswap.h"
>  #include "memory.h"
>  #include "exec-memory.h"
> +#include "iorange.h"
> +#include "qemu-objects.h"
>  
>  /* This check must be after config-host.h is included */
>  #ifdef CONFIG_EVENTFD
> @@ -1707,3 +1710,84 @@ int kvm_on_sigbus(int code, void *addr)
>  {
>      return kvm_arch_on_sigbus(code, addr);
>  }
> +
> +/* Possible values for action parameter. */
> +#define PANICKED_REPORT 1   /* emit QEVENT_GUEST_PANICKED only */
> +#define PANICKED_PAUSE  2   /* emit QEVENT_GUEST_PANICKED and pause VM */
> +#define PANICKED_QUIT   3   /* emit QEVENT_GUEST_PANICKED and quit VM */
> +
> +static int panicked_action = PANICKED_REPORT;
> +
> +static void kvm_pv_port_read(IORange *iorange, uint64_t offset, unsigned width,
> +                             uint64_t *data)
> +{
> +    *data = (1 << KVM_PV_FEATURE_PANICKED);
> +}
> +
> +static void panicked_mon_event(const char *action)
> +{
> +    QObject *data;
> +
> +    data = qobject_from_jsonf("{ 'action': %s }", action);
> +    monitor_protocol_event(QEVENT_GUEST_PANICKED, data);
> +    qobject_decref(data);
> +}
> +
> +static void panicked_perform_action(void)
> +{
> +    switch(panicked_action) {
> +    case PANICKED_REPORT:
> +        panicked_mon_event("report");
> +        break;
> +
> +    case PANICKED_PAUSE:
> +        panicked_mon_event("pause");
> +        vm_stop(RUN_STATE_GUEST_PANICKED);
> +        break;
> +
> +    case PANICKED_QUIT:
> +        panicked_mon_event("quit");
> +        exit(0);
> +        break;
> +    }

Having the data argument is not needed/wanted. The mngt app can guess it if it
needs to know it, but I think it doesn't want to.

> +}
> +
> +static void kvm_pv_port_write(IORange *iorange, uint64_t offset, unsigned width,
> +                              uint64_t data)
> +{
> +    if (data == KVM_PV_PANICKED)
> +        panicked_perform_action();
> +}
> +
> +static void kvm_pv_port_destructor(IORange *iorange)
> +{
> +    g_free(iorange);
> +}
> +
> +static IORangeOps pv_io_range_ops = {
> +    .read = kvm_pv_port_read,
> +    .write = kvm_pv_port_write,
> +    .destructor = kvm_pv_port_destructor,
> +};
> +
> +void kvm_pv_port_init(void)
> +{
> +    IORange *pv_io_range = g_malloc(sizeof(IORange));
> +
> +    iorange_init(pv_io_range, &pv_io_range_ops, 0x505, 1);
> +    ioport_register(pv_io_range);
> +}
> +
> +int select_panicked_action(const char *p)
> +{
> +    if (strcasecmp(p, "report") == 0)
> +        panicked_action = PANICKED_REPORT;
> +    else if (strcasecmp(p, "pause") == 0)
> +        panicked_action = PANICKED_PAUSE;
> +    else if (strcasecmp(p, "quit") == 0)
> +        panicked_action = PANICKED_QUIT;
> +    else
> +        return -1;
> +
> +    return 0;
> +}
> diff --git a/kvm-stub.c b/kvm-stub.c
> index 47c573d..4cf977e 100644
> --- a/kvm-stub.c
> +++ b/kvm-stub.c
> @@ -128,3 +128,12 @@ int kvm_on_sigbus(int code, void *addr)
>  {
>      return 1;
>  }
> +
> +void kvm_pv_port_init(void)
> +{
> +}
> +
> +int select_panicked_action(const char *p)
> +{
> +    return -1;
> +}
> diff --git a/kvm.h b/kvm.h
> index 4ccae8c..95075cf 100644
> --- a/kvm.h
> +++ b/kvm.h
> @@ -60,6 +60,9 @@ int kvm_has_gsi_routing(void);
>  
>  int kvm_allows_irq0_override(void);
>  
> +void kvm_pv_port_init(void);
> +int select_panicked_action(const char *p);
> +
>  #ifdef NEED_CPU_H
>  int kvm_init_vcpu(CPUArchState *env);
>  
> diff --git a/monitor.c b/monitor.c
> index 12a6fe2..83cb059 100644
> --- a/monitor.c
> +++ b/monitor.c
> @@ -493,6 +493,9 @@ void monitor_protocol_event(MonitorEvent event, QObject *data)
>          case QEVENT_WAKEUP:
>              event_name = "WAKEUP";
>              break;
> +        case QEVENT_GUEST_PANICKED:
> +            event_name = "GUEST_PANICKED";
> +            break;
>          default:
>              abort();
>              break;
> diff --git a/monitor.h b/monitor.h
> index 0d49800..94e8a3c 100644
> --- a/monitor.h
> +++ b/monitor.h
> @@ -41,6 +41,7 @@ typedef enum MonitorEvent {
>      QEVENT_DEVICE_TRAY_MOVED,
>      QEVENT_SUSPEND,
>      QEVENT_WAKEUP,
> +    QEVENT_GUEST_PANICKED,
>      QEVENT_MAX,
>  } MonitorEvent;
>  
> diff --git a/qapi-schema.json b/qapi-schema.json
> index 2ca7195..ee5c9e9 100644
> --- a/qapi-schema.json
> +++ b/qapi-schema.json
> @@ -119,11 +119,15 @@
>  # @suspended: guest is suspended (ACPI S3)
>  #
>  # @watchdog: the watchdog action is configured to pause and has been triggered
> +#
> +# @guest-panicked: the panicked action is configured to pause and has been
> +# triggered.
>  ##
>  { 'enum': 'RunState',
>    'data': [ 'debug', 'inmigrate', 'internal-error', 'io-error', 'paused',
>              'postmigrate', 'prelaunch', 'finish-migrate', 'restore-vm',
> -            'running', 'save-vm', 'shutdown', 'suspended', 'watchdog' ] }
> +            'running', 'save-vm', 'shutdown', 'suspended', 'watchdog',
> +            'guest-panicked' ] }
>  
>  ##
>  # @StatusInfo:
> diff --git a/qemu-options.hx b/qemu-options.hx
> index 8b66264..d3d21a1 100644
> --- a/qemu-options.hx
> +++ b/qemu-options.hx
> @@ -2743,6 +2743,20 @@ DEF("qtest-log", HAS_ARG, QEMU_OPTION_qtest_log,
>      "-qtest-log LOG  specify tracing options\n",
>      QEMU_ARCH_ALL)
>  
> +DEF("onpanic", HAS_ARG, QEMU_OPTION_onpanic, \
> +    "-onpanic report|pause|quit\n" \
> +    "                action when the guest is panicked [default=report]",
> +    QEMU_ARCH_ALL)
> +STEXI
> +@item -onpanic @var{action}
> +
> +The @var{action} controls what QEmu will do when the guest is panicked.
> +The default is @code{report} (emit QEVENT_GUEST_PANICKED only).
> +Other possible actions are:
> +@code{pause} (emit QEVENT_GUEST_PANICKED and pause VM),
> +@code{quit} (emit QEVENT_GUEST_PANICKED and quit VM).
> +ETEXI
> +
>  HXCOMM This is the last statement. Insert new options before this line!
>  STEXI
>  @end table
> diff --git a/qmp.c b/qmp.c
> index fee9fb2..a2d5ce9 100644
> --- a/qmp.c
> +++ b/qmp.c
> @@ -148,7 +148,8 @@ void qmp_cont(Error **errp)
>          error_set(errp, QERR_MIGRATION_EXPECTED);
>          return;
>      } else if (runstate_check(RUN_STATE_INTERNAL_ERROR) ||
> -               runstate_check(RUN_STATE_SHUTDOWN)) {
> +               runstate_check(RUN_STATE_SHUTDOWN) ||
> +               runstate_check(RUN_STATE_GUEST_PANICKED)) {
>          error_set(errp, QERR_RESET_REQUIRED);
>          return;
>      } else if (runstate_check(RUN_STATE_SUSPENDED)) {
> diff --git a/vl.c b/vl.c
> index 7f5fed8..8848506 100644
> --- a/vl.c
> +++ b/vl.c
> @@ -367,6 +367,7 @@ static const RunStateTransition runstate_transitions_def[] = {
>      { RUN_STATE_RUNNING, RUN_STATE_SAVE_VM },
>      { RUN_STATE_RUNNING, RUN_STATE_SHUTDOWN },
>      { RUN_STATE_RUNNING, RUN_STATE_WATCHDOG },
> +    { RUN_STATE_RUNNING, RUN_STATE_GUEST_PANICKED },
>  
>      { RUN_STATE_SAVE_VM, RUN_STATE_RUNNING },
>  
> @@ -381,6 +382,9 @@ static const RunStateTransition runstate_transitions_def[] = {
>      { RUN_STATE_WATCHDOG, RUN_STATE_RUNNING },
>      { RUN_STATE_WATCHDOG, RUN_STATE_FINISH_MIGRATE },
>  
> +    { RUN_STATE_GUEST_PANICKED, RUN_STATE_PAUSED },
> +    { RUN_STATE_GUEST_PANICKED, RUN_STATE_FINISH_MIGRATE },
> +
>      { RUN_STATE_MAX, RUN_STATE_MAX },
>  };
>  
> @@ -1537,7 +1541,8 @@ static bool main_loop_should_exit(void)
>          qemu_system_reset(VMRESET_REPORT);
>          resume_all_vcpus();
>          if (runstate_check(RUN_STATE_INTERNAL_ERROR) ||
> -            runstate_check(RUN_STATE_SHUTDOWN)) {
> +            runstate_check(RUN_STATE_SHUTDOWN) ||
> +            runstate_check(RUN_STATE_GUEST_PANICKED)) {
>              runstate_set(RUN_STATE_PAUSED);
>              vm_start();
>          }
> @@ -3202,6 +3207,12 @@ int main(int argc, char **argv, char **envp)
>              case QEMU_OPTION_qtest_log:
>                  qtest_log = optarg;
>                  break;
> +            case QEMU_OPTION_onpanic:
> +                if (select_panicked_action(optarg) == -1) {
> +                    fprintf(stderr, "Unknown -onpanic parameter\n");
> +                    exit(1);
> +                }
> +                break;
>              default:
>                  os_parse_cmd_args(popt->index, optarg);
>              }
> @@ -3634,6 +3645,10 @@ int main(int argc, char **argv, char **envp)
>          }
>      }
>  
> +    if (kvm_enabled()) {
> +        kvm_pv_port_init();
> +    }
> +
>      if (incoming) {
>          Error *errp = NULL;
>          int ret = qemu_start_incoming_migration(incoming, &errp);

