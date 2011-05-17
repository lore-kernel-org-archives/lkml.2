Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932443Ab1EQWEX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 18:04:23 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55488 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932389Ab1EQWEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 18:04:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=ekIANXc39JceeFJh36kMmnFHqE/YlTWkrQIijdj82NJKmBinLfyylWLWrgUueF+HQp
         ir6WXnuwColhdzJlIUFGevulGOuiiEO09MlhKaQrTAGoMG10wtbYbjCMZHYiP37tgQ9V
         ZsdDqVZX/DdUspje/3vZcLMi+jBNIoh8YytmA=
Message-ID: <4DD2F0E2.10100@gmail.com>
Date: Wed, 18 May 2011 00:04:18 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: John Stultz <john.stultz@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        Michal Nazarewicz <mina86@mina86.com>,
        Andy Whitcroft <apw@canonical.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] printk: Add %ptc to safely print a task's comm
References: <1305665263-20933-1-git-send-email-john.stultz@linaro.org>	 <1305665263-20933-3-git-send-email-john.stultz@linaro.org>	 <4DD2EBAB.5080004@gmail.com> <1305669150.1722.83.camel@Joe-Laptop>
In-Reply-To: <1305669150.1722.83.camel@Joe-Laptop>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2011 11:52 PM, Joe Perches wrote:
> On Tue, 2011-05-17 at 23:42 +0200, Jiri Slaby wrote:
>> On 05/17/2011 10:47 PM, John Stultz wrote:
>>> Accessing task->comm requires proper locking. However in the past
>>> access to current->comm could be done without locking. This
>>> is no longer the case, so all comm access needs to be done
>>> while holding the comm_lock.
>>> +static noinline_for_stack
>> I still fail to see why this should be slowed down by noinlining it.
>> Care to explain?
> 
> Any vsprintf is slow.
> 
>> With my setup, the code below inlined will use 32 bytes of stack. The
>> same as %pK case. Uninlined it obviously eats "only" 8 bytes for IP.
> 
> The idea is to avoid excess stack consumption for things like:
> 
> 	struct va_format vaf;
> 
> 	const char *fmt = "some format with %ptc";
> 
> 	vaf.fmt = fmt;
> 	vaf.va = &va_list;
> 
> 	printk("some format with %pV\n", &vaf);

There is no way how can noinline_for_stack for task_comm_string lower
the stack usage here, right? Note that it adds no more requirements to
the stack than there were before. Simply because there are no buffers on
the stack in task_comm_string.

If nothing, it saves 100 bytes of .text.

thanks,
-- 
js
