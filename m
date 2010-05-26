Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093Ab0EZM6W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 08:58:22 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61669 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673Ab0EZM6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 08:58:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=lTaEVDGbcCxjKbtw5SUXPudiPs00zVTY9r85ATiasVfcIjFyNikUQxpIBE1pQZaRrk
         YdTCrfy0TkTU5s+6ODPUM/zQEOQfDb3Ui6yJiImxdWPWr/ICD80xZ3wu+2JZC3buXS+P
         FUp0bgWNfPPjKPoVJllXRe6VybBDAGvIoTu1w=
Message-ID: <4BFD1ADD.7020004@gmail.com>
Date: Wed, 26 May 2010 14:58:05 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.4) Gecko/20100522 SUSE/3.1rc1-2.1 Thunderbird/3.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: adobriyan@gmail.com, nhorman@tuxdriver.com, oleg@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 10/11] rlimits: implement prlimit64 syscall
References: <1273514451-28894-1-git-send-email-jslaby@suse.cz>	<1273514451-28894-10-git-send-email-jslaby@suse.cz> <20100513155630.9ca5ab16.akpm@linux-foundation.org>
In-Reply-To: <20100513155630.9ca5ab16.akpm@linux-foundation.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2010 12:56 AM, Andrew Morton wrote:
> On Mon, 10 May 2010 20:00:50 +0200
> Jiri Slaby <jslaby@suse.cz> wrote:
> 
>> This patch adds the code to support the sys_prlimit64 syscall which
>> modifies-and-returns the rlim values of a selected process
>> atomically. The first parameter, pid, being 0 means current process.
>>
>> Unlike the current implementation, it is a generic interface,
>> architecture indepentent so that we needn't handle compat stuff
>> anymore. In the future, after glibc start to use this we can deprecate
>> sys_setrlimit and sys_getrlimit in favor to clean up the code finally.
>>
>> It also adds a possibility of changing limits of other processes. We
>> check the user's permissions to do that and if it succeeds, the new
>> limits are propagated online. This is good for large scale
>> applications such as SAP or databases where administrators need to
>> change limits time by time (e.g. on crashes increase core size). And
>> it is unacceptable to restart the service.
>>
>> For safety, all rlim users now either use accessors or doesn't need
>> them due to
>> - locking
>> - the fact a process was just forked and nobody else knows about it
>>   yet (and nobody can't thus read/write limits)
>> hence it is safe to modify limits now.
>>
>> The limitation is that we currently stay at ulong internal
>> representation. So we use the rlim64_is_infinity check where we
>> compare to ULONG_MAX on 32-bit which is the maximum value there.
>>
>> And since internally we hold limits in struct rlimit, we introduce
>> converters used before and after do_prlimit call in sys_prlimit64.
>>
> 
> Is this worth all the new code and the increase in locking dependencies
> which I think is there?

Sorry, for the late reply, I was busy with other things.

Both
tasklist_lock -> (task_struct->sighand->siglock)
tasklist_lock -> (task_struct->alloc_lock)
are OK, since both dependencies already exist in the kernel.

This should have been in the changelogs, yes!

> This could all be done in userspace, couldn't it?  Write a little library
> which clones a thread then waits for someone to send it a
> change-your-rlimits message.  Write a little tool to send those
> messages and voila.

Sorry, I'm not sure I understand this. Could you shed some light on what
will run in the new thread?

A code such as:
main()
{
  if (!clone())
    exec("something");

  while (wait_for_message(&m)) {
     setrlimit(m);
     sleep();
  }
}
won't obviously work. Could you change it so it reflects your idea or
explain what I'm missing?

thanks,
-- 
js
