Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647Ab0ELXgA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 19:36:00 -0400
Received: from smtp-out.google.com ([74.125.121.35]:9262 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702Ab0ELXf6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 19:35:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=XiwWYnVYiDzV7EMzdecQyjXHoo5neStfLDpYp+BjbqzeY9keGxwj+9VpkXs/O/hXI
	ynMEntlLBLGJE/pnIiwKA==
MIME-Version: 1.0
In-Reply-To: <20100513074949.2136.A69D9226@jp.fujitsu.com>
References: <1273634462-2672-1-git-send-email-walken@google.com>
	 <1273634462-2672-13-git-send-email-walken@google.com>
	 <20100513074949.2136.A69D9226@jp.fujitsu.com>
Date: Wed, 12 May 2010 16:35:53 -0700
Message-ID: <n2z8d20b11a1005121635qaa544981v620374f43c15945d@mail.gmail.com>
Subject: Re: [PATCH 12/12] Use down_read_unfair() for /sys/<pid>/exe and 
	/sys/<pid>/maps files
From: Michel Lespinasse <walken@google.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Waychison <mikew@google.com>,
       Suleiman Souhlal <suleiman@google.com>, Ying Han <yinghan@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 12, 2010 at 3:53 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> This helps in the following situation:
>> - Thread A takes a page fault while reading or writing memory.
>>   do_page_fault() acquires the mmap_sem for read and blocks on disk
>>   (either reading the page from file, or hitting swap) for a long time.
>> - Thread B does an mmap call and blocks trying to acquire the mmap_sem
>>   for write
>> - Thread C is a monitoring process trying to read every /proc/pid/maps
>>   in the system. This requires acquiring the mmap_sem for read. Thread C
>>   blocks behind B, waiting for A to release the rwsem.  If thread C
>>   could be allowed to run in parallel with A, it would probably get done
>>   long before thread A's disk access completes, thus not actually slowing
>>   down thread B.
>>
>> Test results with down_read_unfair_test (10 seconds):
>>
>> 2.6.33.3:
>> threadA completes ~600 faults
>> threadB completes ~300 mmap/munmap cycles
>> threadC completes ~600 /proc/pid/maps reads
>>
>> 2.6.33.3 + down_read_unfair:
>> threadA completes ~600 faults
>> threadB completes ~300 mmap/munmap cycles
>> threadC completes ~160000 /proc/pid/maps reads
>>
>> Signed-off-by: Michel Lespinasse <walken@google.com>
>
> Is it good idea?
> So I think /proc shouldn't use unfair thing as backdoor.
> It doesn't only makes performance improvement, but also
> DoS chance is there.

I am not entirely surprised that there is some level of opposition to
this change (which is in part why it went last in the series).

Besides keeping it internal, would there be ways to make it acceptable
to the community ? For example, would it be fine if unfair behavior
was only used if the caller thread runs with root priviledge ?

In my opinion the optimal behavior would be if the rwsem could be
allowed to be grabbed unfairly only as long as there are still fair
readers on it. However, I don't see how to achieve this given that we
don't want to slow down the regular, fair code paths.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
