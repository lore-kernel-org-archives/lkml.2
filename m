Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534Ab0GGNGJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 09:06:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:56584 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755006Ab0GGNGG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 09:06:06 -0400
Date: Wed, 7 Jul 2010 15:05:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: avi@redhat.com, linux-kernel@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Gleb Natapov <gleb@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
       Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] x86: KVM, fix lock imbalance
Message-ID: <20100707130545.GA14934@elte.hu>
References: <1278507745-32746-1-git-send-email-jirislaby@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278507745-32746-1-git-send-email-jirislaby@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jiri Slaby <jirislaby@gmail.com> wrote:

> Stanse found that there is an omitted unlock in kvm_create_pit in one fail
> path. Add proper unlock there.
> 
> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
> Cc: Avi Kivity <avi@redhat.com>
> Cc: Marcelo Tosatti <mtosatti@redhat.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: x86@kernel.org
> Cc: Gleb Natapov <gleb@redhat.com>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Gregory Haskins <ghaskins@novell.com>
> Cc: kvm@vger.kernel.org
> ---
>  arch/x86/kvm/i8254.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
> index 467cc47..70db4d4 100644
> --- a/arch/x86/kvm/i8254.c
> +++ b/arch/x86/kvm/i8254.c
> @@ -696,6 +696,7 @@ struct kvm_pit *kvm_create_pit(struct kvm *kvm, u32 flags)
>  
>  	pit->wq = create_singlethread_workqueue("kvm-pit-wq");
>  	if (!pit->wq) {
> +		mutex_unlock(&pit->pit_state.lock);
>  		kfree(pit);
>  		return NULL;
>  	}

A cleanliness comment: why is that tear-down/dealloc sequence open-coded? It 
should be at the end of the function, with goto labels, like we do it in 
similar cases.

Thanks,

	Ingo
