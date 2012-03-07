Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab2CGJyM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 04:54:12 -0500
Received: from goliath.siemens.de ([192.35.17.28]:25037 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751137Ab2CGJyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 04:54:09 -0500
Message-ID: <4F57302B.1040505@siemens.com>
Date: Wed, 07 Mar 2012 10:53:47 +0100
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
Subject: Re: [PATCH v2] deal with guest paniced event
References: <4F56BEF2.4020405@cn.fujitsu.com> <4F56C0E1.1090703@cn.fujitsu.com>
In-Reply-To: <4F56C0E1.1090703@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-03-07 02:58, Wen Congyang wrote:
> When the host knows the guest is paniced, it will set
> exit_reason to KVM_EXIT_GUEST_PANICED. So if qemu receive
> this exit_reason, we can send a event to tell management
> application that the guest is paniced and set the guest
> status to RUN_STATE_PANICED.
> 
> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
> ---
>  kvm-all.c                 |    4 ++++
>  linux-headers/linux/kvm.h |    1 +
>  monitor.c                 |    3 +++
>  monitor.h                 |    1 +
>  qapi-schema.json          |    2 +-
>  qmp.c                     |    3 ++-
>  vl.c                      |    1 +
>  7 files changed, 13 insertions(+), 2 deletions(-)
> 
> diff --git a/kvm-all.c b/kvm-all.c
> index c4babda..d356948 100644
> --- a/kvm-all.c
> +++ b/kvm-all.c
> @@ -1190,6 +1190,10 @@ int kvm_cpu_exec(CPUState *env)
>                      (uint64_t)run->hw.hardware_exit_reason);
>              ret = -1;
>              break;
> +        case KVM_EXIT_GUEST_PANICED:
> +            monitor_protocol_event(QEVENT_GUEST_PANICED, NULL);
> +            vm_stop(RUN_STATE_PANICED);
> +            break;

This cannot work. You missed to set ret to -1 to break out of loop.

>          case KVM_EXIT_INTERNAL_ERROR:
>              ret = kvm_handle_internal_error(env, run);
>              break;
> diff --git a/linux-headers/linux/kvm.h b/linux-headers/linux/kvm.h
> index f6b5343..ddc9716 100644
> --- a/linux-headers/linux/kvm.h
> +++ b/linux-headers/linux/kvm.h
> @@ -163,6 +163,7 @@ struct kvm_pit_config {
>  #define KVM_EXIT_OSI              18
>  #define KVM_EXIT_PAPR_HCALL	  19
>  #define KVM_EXIT_S390_UCONTROL	  20
> +#define KVM_EXIT_GUEST_PANICED	  21

Linux header must be sync'ed in a separate patch, referencing the
upstream (typically kvm.git) commit hash that was used as base. Make
sure to use the update-linux-headers.sh script for this.

So the ordering is: Get the kernel changes accepted, then push the
(final) user space patches. That said, a patch like this can still be
posted in advance for informational purposes, but not for application.

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
