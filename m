Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755628Ab0GGNHd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 09:07:33 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39470 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755453Ab0GGNHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 09:07:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=WIAGgBVrvibbZMvBbpr9pRzCiAUKVY6ERgxaAVSzUfTOnggnnfKtF1ngsJC9PeRrSb
         gYFQUW7lhTQNzCc6xx1c3kzma98YBUjum4NGJWCWeNq/trOPsV7rSdioKfA8cDxj57TZ
         ZJXLprP1dFOg5BxI41PtHJUbrI9lP7ZjuKtdM=
Message-ID: <4C347C0E.6020107@gmail.com>
Date: Wed, 07 Jul 2010 15:07:26 +0200
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
References: <1278507745-32746-1-git-send-email-jirislaby@gmail.com> <20100707130545.GA14934@elte.hu>
In-Reply-To: <20100707130545.GA14934@elte.hu>
X-Enigmail-Version: 1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2010 03:05 PM, Ingo Molnar wrote:
> 
> * Jiri Slaby <jirislaby@gmail.com> wrote:
> 
>> Stanse found that there is an omitted unlock in kvm_create_pit in one fail
>> path. Add proper unlock there.
>>
>> Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
>> Cc: Avi Kivity <avi@redhat.com>
>> Cc: Marcelo Tosatti <mtosatti@redhat.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: "H. Peter Anvin" <hpa@zytor.com>
>> Cc: x86@kernel.org
>> Cc: Gleb Natapov <gleb@redhat.com>
>> Cc: "Michael S. Tsirkin" <mst@redhat.com>
>> Cc: Gregory Haskins <ghaskins@novell.com>
>> Cc: kvm@vger.kernel.org
>> ---
>>  arch/x86/kvm/i8254.c |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/arch/x86/kvm/i8254.c b/arch/x86/kvm/i8254.c
>> index 467cc47..70db4d4 100644
>> --- a/arch/x86/kvm/i8254.c
>> +++ b/arch/x86/kvm/i8254.c
>> @@ -696,6 +696,7 @@ struct kvm_pit *kvm_create_pit(struct kvm *kvm, u32 flags)
>>  
>>  	pit->wq = create_singlethread_workqueue("kvm-pit-wq");
>>  	if (!pit->wq) {
>> +		mutex_unlock(&pit->pit_state.lock);
>>  		kfree(pit);
>>  		return NULL;
>>  	}
> 
> A cleanliness comment: why is that tear-down/dealloc sequence open-coded? It 
> should be at the end of the function, with goto labels, like we do it in 
> similar cases.

Because the lock is around a block only. I usually don't create a goto
fail-paths in these cases. Do you want one?

thanks,
-- 
js
