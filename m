Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758162Ab2CAQvr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 11:51:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26638 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757057Ab2CAQvp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 11:51:45 -0500
Date: Thu, 1 Mar 2012 13:51:39 -0300
From: Luiz Capitulino <lcapitulino@redhat.com>
To: Wen Congyang <wency@cn.fujitsu.com>
Cc: kvm list <kvm@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "Daniel P. Berrange" <berrange@redhat.com>,
        linux-kernel@vger.kernel.org, qemu-devel <qemu-devel@nongnu.org>
Subject: Re: [Qemu-devel] [PATCH]qemu: deal with guest paniced event
Message-ID: <20120301135139.5f2b2a5c@doriath.home>
In-Reply-To: <4F4AF316.50400@cn.fujitsu.com>
References: <4F4AF1FB.6000903@cn.fujitsu.com>
	<4F4AF316.50400@cn.fujitsu.com>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Feb 2012 11:05:58 +0800
Wen Congyang <wency@cn.fujitsu.com> wrote:

> When the host knows the guest is paniced, it will set
> exit_reason to KVM_EXIT_GUEST_PANIC. So if qemu receive
> this exit_reason, we can send a event to tell management
> application that the guest is paniced.
> 
> Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
> ---
>  kvm-all.c                 |    3 +++
>  linux-headers/linux/kvm.h |    1 +
>  monitor.c                 |    3 +++
>  monitor.h                 |    1 +
>  4 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/kvm-all.c b/kvm-all.c
> index c4babda..ae428ab 100644
> --- a/kvm-all.c
> +++ b/kvm-all.c
> @@ -1190,6 +1190,9 @@ int kvm_cpu_exec(CPUState *env)
>                      (uint64_t)run->hw.hardware_exit_reason);
>              ret = -1;
>              break;
> +        case KVM_EXIT_GUEST_PANIC:
> +            monitor_protocol_event(QEVENT_GUEST_PANICED, NULL);
> +            break;

The event alone is not enough, because the mngt app may miss it (eg. the panic
happens before the mngt app connected to qemu).

A simple way to solve this would be to also add a new RunState called
guest-panic and make the transition to it (besides sending the event).

A more general way would be to model this after -drive's werror/rerror options,
say guest-error=report|ignore|stop. When guest-error=stop, the mngt app will
get a STOP event and can check the VM runstate to know if it's guest-panic.
