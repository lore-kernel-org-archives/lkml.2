Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab0KAWm3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 18:42:29 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54907 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab0KAWm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 18:42:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Ul9L6qyRQ76PqNorgjhjEunf6hg4STNP0p+2ry+ndfc/vy+5SltGUd/EURr0OSnsJH
         w4xn+NKaneIAL8EtAiNkRDprMRsdBLxrffxijlI4DTIp2QUZzUiwd3gwTU1D39tEdA1S
         TUuKFunz8IdS7PeisWMtB+chPUnk1Nc/2kJ0w=
Message-ID: <4CCF424F.3050205@redhat.com>
Date: Mon, 01 Nov 2010 23:42:23 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Mnenhy/0.8.3 Thunderbird/3.1.4
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>
CC: dhowells@redhat.com, lizf@cn.fujitsu.com, paul.moore@hp.com,
        johannes@sipsolutions.net, dipankar@in.ibm.com,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH 2/3] kernel,cred,kvm,security - removing superfluous rcu_read_lock_held
 check
References: <1288638909-10541-1-git-send-email-jolsa@redhat.com> <1288638909-10541-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1288638909-10541-3-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2010 08:15 PM, Jiri Olsa wrote:
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index a055742..a90a7e3 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -256,7 +256,6 @@ void kvm_put_kvm(struct kvm *kvm);
>   static inline struct kvm_memslots *kvm_memslots(struct kvm *kvm)
>   {
>   	return rcu_dereference_check(kvm->memslots,
> -			srcu_read_lock_held(&kvm->srcu)
>   			|| lockdep_is_held(&kvm->slots_lock));
>   }
>

This is an srcu_read_lock_held, which you don't touch here:

> diff --git a/kernel/rcutorture.c b/kernel/rcutorture.c
> index 9d8e8fb..0956a73 100644
> --- a/kernel/rcutorture.c
> +++ b/kernel/rcutorture.c
> @@ -807,7 +807,6 @@ static void rcu_torture_timer(unsigned long unused)
>  	idx = cur_ops->readlock();
>  	completed = cur_ops->completed();
>  	p = rcu_dereference_check(rcu_torture_current,
> -				  rcu_read_lock_held() ||
>  				  rcu_read_lock_bh_held() ||
>  				  rcu_read_lock_sched_held() ||
>  				  srcu_read_lock_held(&srcu_ctl));

I guess the kvm hunk is the incorrect one?

Paolo
