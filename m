Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757030Ab1FGSfN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 14:35:13 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48709 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814Ab1FGSfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 14:35:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=KGtVbSMgRv3JZDENhult1W9pfQhAQp7r8MpHBKxB03hEgn4MLoyi23QEZbScNTjJJD
         ILpDGUcYnZaZNhUarcXydgbSNnVTu/mn/u/9tPQMQKHmubDTAqoYiBNnwYe/ASbO72Ix
         7RsvnSHK3i5H5c6UDYLhjRt9Da3J7v9Dd722o=
Message-ID: <4DEE6E33.6020701@gmail.com>
Date: Tue, 07 Jun 2011 20:30:11 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110531 Thunderbird/5.0b1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Jiri Slaby <jslaby@suse.cz>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Al Viro <viro@zeniv.linux.org.uk>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH v2 1/2] coredump: use task comm instead of (unknown)
References: <1307457010-7241-1-git-send-email-jslaby@suse.cz> <20110607181607.GA3732@redhat.com>
In-Reply-To: <20110607181607.GA3732@redhat.com>
X-Enigmail-Version: 1.2a2pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/07/2011 08:16 PM, Oleg Nesterov wrote:
> On 06/07, Jiri Slaby wrote:
>>
>> @@ -1631,7 +1631,7 @@ static int cn_print_exe_file(struct core_name *cn)
>>
>>  	exe_file = get_mm_exe_file(current->mm);
>>  	if (!exe_file)
>> -		return cn_printf(cn, "(unknown)");
>> +		return cn_printf(cn, "%s (path unknown)", current->comm);
> 
> Hmm. The patch itself looks fine to me.
> 
> Acked-by: Oleg Nesterov <oleg@redhat.com>
> 
> 
> 
> But the code looks wrong.
> 
> What if d_path() fails with, say, ENAMETOOLONG? do_coredump() doesn't
> expect an error code != ENOMEM. This is just ugly, I'll send the simple
> fix. Anyway, if we are changing cn_print_exe_file(), perhaps it makes
> sense to fallback if d_path fails too?

Ah, I see. Perhaps it should check '< 0' instead of '== -ENOMEM' and
print the error in that case?

> And, I am just noticed...
> 
> 	for (p = path; *p; p++)
> 		if (*p == '/')
> 			*p = '!';
> 
> Why??? I am not arguing, just curious.

In fact the reason is in the patch 2/2:
    coredump: escape / in hostname and comm

    Change every occurence of / in comm and hostname to !. If the process
    changes its name to contain /, the core is not dumped (if the
    directory tree doesn't exist like that). The same with hostname being
    something like myhost/3. Fix this behaviour by using the escape loop
    used in %E. (We extract it to a separate function.)

    Now both with comm == myprocess/1 and hostname == myhost/1, the core
    is dumped like (kernel.core_pattern='core.%p.%e.%h):
    core.2349.myprocess!1.myhost!1

thanks,
-- 
js
