Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab1LAOiH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 09:38:07 -0500
Received: from goliath.siemens.de ([192.35.17.28]:16185 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665Ab1LAOiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 09:38:05 -0500
Message-ID: <4ED79138.60603@siemens.com>
Date: Thu, 01 Dec 2011 15:37:44 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Eric B Munson <emunson@mgebm.net>
CC: qemu-devel@nongnu.org, ryanh@linux.vnet.ibm.com, aliguori@us.ibm.com,
        kvm@vger.kernel.org, mtosatti@redhat.com, linux-kernel@vger.kernel.org,
        avi@redhat.com
Subject: Re: [PATCH] Guest stop notification
References: <1322602574-27072-1-git-send-email-emunson@mgebm.net>
In-Reply-To: <1322602574-27072-1-git-send-email-emunson@mgebm.net>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-11-29 22:36, Eric B Munson wrote:
> Often when a guest is stopped from the qemu console, it will report spurious
> soft lockup warnings on resume.  There are kernel patches being discussed that
> will give the host the ability to tell the guest that it is being stopped and
> should ignore the soft lockup warning that generates.
> 
> Signed-off-by: Eric B Munson <emunson@mgebm.net>
> Cc: ryanh@linux.vnet.ibm.com
> Cc: aliguori@us.ibm.com
> Cc: mtosatti@redhat.com
> Cc: avi@redhat.com
> Cc: kvm@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  target-i386/kvm.c |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/target-i386/kvm.c b/target-i386/kvm.c
> index 5bfc21f..defd364 100644
> --- a/target-i386/kvm.c
> +++ b/target-i386/kvm.c
> @@ -336,12 +336,18 @@ static int kvm_inject_mce_oldstyle(CPUState *env)
>      return 0;
>  }
>  
> +static void kvm_put_guest_paused(CPUState *penv)
> +{
> +    kvm_vcpu_ioctl(penv, KVM_GUEST_PAUSED, 0);
> +}

I see no need in encapsulating this in a separate function.

> +
>  static void cpu_update_state(void *opaque, int running, RunState state)
>  {
>      CPUState *env = opaque;
>  
>      if (running) {
>          env->tsc_valid = false;
> +	kvm_put_guest_paused(env);

checkpatch.pl would have asked you to remove this tab.

More general:

Why is this x86-only? If the kernel interface is x86-only, what prevents
making it generic right from the beginning?

Why do we need a new IOCTL for this? Was there no space left in the
kvm_run structure e.g. to pass this flag down on next vcpu execution? No
big deal, just wondering.

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
