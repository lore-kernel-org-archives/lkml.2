Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757011Ab2GFLKD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 07:10:03 -0400
Received: from goliath.siemens.de ([192.35.17.28]:23392 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533Ab2GFLKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 07:10:00 -0400
Message-ID: <4FF6C77B.208@siemens.com>
Date: Fri, 06 Jul 2012 13:09:47 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Wen Congyang <wency@cn.fujitsu.com>
CC: kvm list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH 7/7 v6] deal with panicked event accoring to '-machine
 panic_action=action'
References: <4FF6B188.2060607@cn.fujitsu.com> <4FF6B2E7.2060405@cn.fujitsu.com>
In-Reply-To: <4FF6B2E7.2060405@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-07-06 11:41, Wen Congyang wrote:
> The action is the same as -onpanic parameter.

As explained in patch 5, now that we have a related device, this no
longer needs to be a machine property.

Would could be a machine property is enabling/disabling this device.
That's probably useful as it uses a fixed PIO port that might conflict
with (non-Linux) guest expectations and/or future device models.

Jan

> 
> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
> ---
>  qemu-config.c   |    4 ++++
>  qemu-options.hx |    4 +++-
>  vl.c            |    7 +++++++
>  3 files changed, 14 insertions(+), 1 deletions(-)
> 
> diff --git a/qemu-config.c b/qemu-config.c
> index 5c3296b..805e7c4 100644
> --- a/qemu-config.c
> +++ b/qemu-config.c
> @@ -595,6 +595,10 @@ static QemuOptsList qemu_machine_opts = {
>              .name = "dt_compatible",
>              .type = QEMU_OPT_STRING,
>              .help = "Overrides the \"compatible\" property of the dt root node",
> +        }, {
> +            .name = "panic_action",
> +            .type = QEMU_OPT_STRING,
> +            .help = "The action what QEMU will do when the guest is panicked",
>          },
>          { /* End of list */ }
>      },
> diff --git a/qemu-options.hx b/qemu-options.hx
> index 4a061bf..083a21d 100644
> --- a/qemu-options.hx
> +++ b/qemu-options.hx
> @@ -33,7 +33,9 @@ DEF("machine", HAS_ARG, QEMU_OPTION_machine, \
>      "                property accel=accel1[:accel2[:...]] selects accelerator\n"
>      "                supported accelerators are kvm, xen, tcg (default: tcg)\n"
>      "                kernel_irqchip=on|off controls accelerated irqchip support\n"
> -    "                kvm_shadow_mem=size of KVM shadow MMU\n",
> +    "                kvm_shadow_mem=size of KVM shadow MMU\n"
> +    "                panic_action=none|pause|poweroff|reset controls what QEmu\n"
> +    "                will do when the guest is panicked",
>      QEMU_ARCH_ALL)
>  STEXI
>  @item -machine [type=]@var{name}[,prop=@var{value}[,...]]
> diff --git a/vl.c b/vl.c
> index 1a68257..091c43b 100644
> --- a/vl.c
> +++ b/vl.c
> @@ -2301,6 +2301,7 @@ int main(int argc, char **argv, char **envp)
>      };
>      const char *trace_events = NULL;
>      const char *trace_file = NULL;
> +    const char *panic_action = NULL;
>  
>      atexit(qemu_run_exit_notifiers);
>      error_set_progname(argv[0]);
> @@ -3372,10 +3373,16 @@ int main(int argc, char **argv, char **envp)
>          kernel_filename = qemu_opt_get(machine_opts, "kernel");
>          initrd_filename = qemu_opt_get(machine_opts, "initrd");
>          kernel_cmdline = qemu_opt_get(machine_opts, "append");
> +        panic_action = qemu_opt_get(machine_opts, "panic_action");
>      } else {
>          kernel_filename = initrd_filename = kernel_cmdline = NULL;
>      }
>  
> +    if (panic_action && select_panicked_action(panic_action) == -1) {
> +        fprintf(stderr, "Unknown -panic_action parameter\n");
> +        exit(1);
> +    }
> +
>      if (!kernel_cmdline) {
>          kernel_cmdline = "";
>      }
> 

-- 
Siemens AG, Corporate Technology, CT RTC ITP SDP-DE
Corporate Competence Center Embedded Linux


