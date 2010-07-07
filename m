Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755373Ab0GGNMV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 09:12:21 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:49377 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838Ab0GGNMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 09:12:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=S9inpqfJ0kGJXyasPYp15qykWzAx7l42MHtqWKA9SDDaBB6pL9zkMQ1ra1i/JZvH0r
         4W6EVnPsncfYUTCovkDBdP3y4T6Ieq+zfy1tvbj/ZVKkhZsz1MLN2wrayTmKAG/gEBq/
         +ydpLJamD20bwoWURm7tZi+g4XGDjUWUQ7yJQ=
Message-ID: <4C347D2F.3080908@gmail.com>
Date: Wed, 07 Jul 2010 15:12:15 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.4) Gecko/20100608 SUSE/3.1.0 Thunderbird/3.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: avi@redhat.com, linux-kernel@vger.kernel.org,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Gleb Natapov <gleb@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>,
       Gregory Haskins <ghaskins@novell.com>, kvm@vger.kernel.org
Subject: Re: [PATCH] x86: KVM, fix lock imbalance
References: <1278507745-32746-1-git-send-email-jirislaby@gmail.com> <20100707130545.GA14934@elte.hu> <4C347C0E.6020107@gmail.com>
In-Reply-To: <4C347C0E.6020107@gmail.com>
X-Enigmail-Version: 1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2010 03:07 PM, Jiri Slaby wrote:
>>> --- a/arch/x86/kvm/i8254.c
>>> +++ b/arch/x86/kvm/i8254.c
>>> @@ -696,6 +696,7 @@ struct kvm_pit *kvm_create_pit(struct kvm *kvm, u32 flags)
>>>  
>>>  	pit->wq = create_singlethread_workqueue("kvm-pit-wq");
>>>  	if (!pit->wq) {
>>> +		mutex_unlock(&pit->pit_state.lock);
>>>  		kfree(pit);
>>>  		return NULL;
>>>  	}
>>
>> A cleanliness comment: why is that tear-down/dealloc sequence open-coded? It 
>> should be at the end of the function, with goto labels, like we do it in 
>> similar cases.
> 
> Because the lock is around a block only. I usually don't create a goto
> fail-paths in these cases.

To be more precise what I mean by that:
if ()
  return;

lock();
...
if () { [single if inside the crit section]
  unlock();
  return;
}
...
unlock()

...
if ()
  return;
...
if ()
  return;

-- 
js
