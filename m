Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975Ab1EFGBj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 02:01:39 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35649 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751923Ab1EFGBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 02:01:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=Dr4ZH6sqWmXfsnSWH7Ws+8MBKZNyUdPgdn+UJK/+cDCYui6lTveHDAK8qBoaP3xUHI
         5Cp6sZAcv+BASVMyA2jaOU9FQ2EX5wK6U7w96hv2vCoJ9wzxZcqRBBDrXJRlgQfLZr8p
         podbUzdO7vPO0dw27GyyOVtvcoziq75Uf7toc=
Message-ID: <4DC38EBD.5060300@suse.cz>
Date: Fri, 06 May 2011 08:01:33 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jirislaby@gmail.com,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Al Viro <viro@zeniv.linux.org.uk>,
        Andi Kleen <andi@firstfloor.org>, John Stultz <john.stultz@linaro.org>,
        Oleg Nesterov <oleg@redhat.com>, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 1/1] coredump: use task comm instead of (unknown)
References: <4DC0FFAB.1000805@gmail.com>	<1304494354-21487-1-git-send-email-jslaby@suse.cz> <20110505150601.a4457970.akpm@linux-foundation.org>
In-Reply-To: <20110505150601.a4457970.akpm@linux-foundation.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ccing Oleg.

On 05/06/2011 12:06 AM, Andrew Morton wrote:
> On Wed,  4 May 2011 09:32:34 +0200
> Jiri Slaby <jslaby@suse.cz> wrote:
> 
>> If we don't know the file corresponding to the binary (i.e. exe_file
>> is unknown), use "task->comm (path unknown)" instead of simple
>> "(unknown)" as suggested by ak.
>>
>> The fallback is the same as %e except it will append "(path unknown)".
>>
>> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
>> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
>> Cc: Al Viro <viro@zeniv.linux.org.uk>
>> Cc: Andi Kleen <andi@firstfloor.org>
>> ---
>>  fs/exec.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/exec.c b/fs/exec.c
>> index 5ee7562..0a4d281 100644
>> --- a/fs/exec.c
>> +++ b/fs/exec.c
>> @@ -1555,7 +1555,7 @@ static int cn_print_exe_file(struct core_name *cn)
>>  
>>  	exe_file = get_mm_exe_file(current->mm);
>>  	if (!exe_file)
>> -		return cn_printf(cn, "(unknown)");
>> +		return cn_printf(cn, "%s (path unknown)", current->comm);
>>  
>>  	pathbuf = kmalloc(PATH_MAX, GFP_TEMPORARY);
>>  	if (!pathbuf) {
> 
> Direct access to current->comm is racy since we added
> prctl(PR_SET_NAME).
> 
> Hopefully John Stultz will soon be presenting us with a %p modifier for
> displaying task_struct.comm.

Then just make sure, you won't nest alloc_lock (task_lock) into siglock.

> But we should get this settled pretty promptly as this is a form of
> userspace-visible API.  Use get_task_comm() for now.

I thought about using get_task_comm, but was not sure, if it is safe to
task_lock() at that place. Note that this is copied from %e.

> Also, there's nothing which prevents userspace from rewriting
> task->comm to something which contains slashes (this seems bad).  If
> that is done, your patch will do Bad Things - it should be modified to
> use cn_print_exe_file()'s slash-overwriting codepath.

%E (cn_print_exe_file) does exactly what %e (format_corename) does. So
if this is really broken in the two ways, we should fix both the old %e
and the new %E.

I'm not sure whether at this point when the task is being killed and
dumped, it can still change comm?

For the slashes, I agree. That should be fixed in both cases.

thanks,
-- 
js
suse labs
