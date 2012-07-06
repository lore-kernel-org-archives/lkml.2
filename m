Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933498Ab2GFLMW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 07:12:22 -0400
Received: from thoth.sbs.de ([192.35.17.2]:25963 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756951Ab2GFLMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 07:12:21 -0400
Message-ID: <4FF6C803.5030502@siemens.com>
Date: Fri, 06 Jul 2012 13:12:03 +0200
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
Subject: Re: [PATCH 6/7 v6] deal with guest panicked event accoring to -onpanic
 parameter
References: <4FF6B188.2060607@cn.fujitsu.com> <4FF6B2C9.10302@cn.fujitsu.com>
In-Reply-To: <4FF6B2C9.10302@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-07-06 11:41, Wen Congyang wrote:
> The onpanic parameter can have the following value:
> 1. none
> 2. pause
> 3. poweroff
> 4. reset
> 
> The action for each value when the guest is panicked:
> 1. none: emit QEVENT_GUEST_PANICKED only
> 2. pause: emit QEVENT_GUEST_PANICKED and pause the guest
> 3. poweroff: emit QEVENT_GUEST_PANICKED and poweroff the guest
> 4. reset: emit QEVENT_GUEST_PANICKED and reset the guest

This is redundant to patch 7 and the preferred device property approach.

Jan

> 
> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
> ---
>  hw/kvm/pv_event.c |   17 +++++++++++++++++
>  qemu-options.hx   |   15 +++++++++++++++
>  vl.c              |    6 ++++++
>  3 files changed, 38 insertions(+), 0 deletions(-)
> 
> diff --git a/hw/kvm/pv_event.c b/hw/kvm/pv_event.c
> index d7ded37..890abcd 100644
> --- a/hw/kvm/pv_event.c
> +++ b/hw/kvm/pv_event.c
> @@ -59,6 +59,23 @@ static void panicked_perform_action(uint32_t panicked_action)
>      }
>  }
>  
> +int select_panicked_action(const char *p)
> +{
> +    if (strcasecmp(p, "none") == 0) {
> +        panicked_action = PANICKED_REPORT;
> +    } else if (strcasecmp(p, "pause") == 0) {
> +        panicked_action = PANICKED_PAUSE;
> +    } else if (strcasecmp(p, "poweroff") == 0) {
> +        panicked_action = PANICKED_POWEROFF;
> +    } else if (strcasecmp(p, "reset") == 0) {
> +        panicked_action = PANICKED_RESET;
> +    } else {
> +        return -1;
> +    }
> +
> +    return 0;
> +}
> +
>  #if defined(KVM_PV_PORT)
>  #include "pv_ioport.c"
>  
> diff --git a/qemu-options.hx b/qemu-options.hx
> index 8b66264..4a061bf 100644
> --- a/qemu-options.hx
> +++ b/qemu-options.hx
> @@ -2743,6 +2743,21 @@ DEF("qtest-log", HAS_ARG, QEMU_OPTION_qtest_log,
>      "-qtest-log LOG  specify tracing options\n",
>      QEMU_ARCH_ALL)
>  
> +DEF("onpanic", HAS_ARG, QEMU_OPTION_onpanic, \
> +    "-onpanic none|pause|poweroff|reset\n" \
> +    "                action when the guest is panicked [default=none]",
> +    QEMU_ARCH_ALL)
> +STEXI
> +@item -onpanic @var{action}
> +
> +The @var{action} controls what QEmu will do when the guest is panicked.
> +The default is @code{none} (emit QEVENT_GUEST_PANICKED only).
> +Other possible actions are:
> +@code{pause} (emit QEVENT_GUEST_PANICKED and pause the guest),
> +@code{poweroff} (emit QEVENT_GUEST_PANICKED and forcefully poweroff the guest),
> +@code{reset} (emit QEVENT_GUEST_PANICKED and forcefully reset the guest).
> +ETEXI
> +
>  HXCOMM This is the last statement. Insert new options before this line!
>  STEXI
>  @end table
> diff --git a/vl.c b/vl.c
> index f5cd28d..1a68257 100644
> --- a/vl.c
> +++ b/vl.c
> @@ -3205,6 +3205,12 @@ int main(int argc, char **argv, char **envp)
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
> 

-- 
Siemens AG, Corporate Technology, CT RTC ITP SDP-DE
Corporate Competence Center Embedded Linux


