Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755454Ab1ISNaY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 09:30:24 -0400
Received: from mail-qw0-f42.google.com ([209.85.216.42]:58688 "EHLO
	mail-qw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753172Ab1ISNaX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 09:30:23 -0400
MIME-Version: 1.0
In-Reply-To: <20110919123100.GJ12765@tamriel.snowman.net>
References: <1316128013-21980-1-git-send-email-andi@firstfloor.org>
	<201109161616.50004.andres@anarazel.de>
	<20110916153620.GA9913@parisc-linux.org>
	<201109161927.34472.andres@anarazel.de>
	<20110916200817.GD28519@kvack.org>
	<20110919123100.GJ12765@tamriel.snowman.net>
Date: Mon, 19 Sep 2011 09:30:22 -0400
Message-ID: <CA+Tgmoa6CP7uwEAcu+d1vVfapj0ZhpYh2UPLZwXHg-VRnbc9QQ@mail.gmail.com>
Subject: Re: [HACKERS] Improve lseek scalability v3
From: Robert Haas <robertmhaas@gmail.com>
To: Stephen Frost <sfrost@snowman.net>
Cc: Benjamin LaHaise <bcrl@kvack.org>, Andres Freund <andres@anarazel.de>,
        Matthew Wilcox <matthew@wil.cx>, Andi Kleen <andi@firstfloor.org>,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, pgsql-hackers@postgresql.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 19, 2011 at 8:31 AM, Stephen Frost <sfrost@snowman.net> wrote:
> * Benjamin LaHaise (bcrl@kvack.org) wrote:
>> For such tables, can't Postgres track the size of the file internally?  I'm
>> assuming it's keeping file descriptors open on the tables it manages, in
>> which case when it writes to a file to extend it, the internally stored size
>> could be updated.  Not making a syscall at all would scale far better than
>> even a modified lseek() will perform.
>
> We'd have to have it in shared memory and have a lock around it, it
> wouldn't be cheap at all.

In theory, we could implement a lock-free cache.  But I still think it
would be better to see this fixed on the kernel side.  If we had some
evidence that all of those lseek() calls were a performance problem
even when the i_mutex is not seriously contended, then that would be a
good argument for doing this in user-space, but I haven't seen any
such evidence.  On the other hand, the numbers I posted show that when
i_mutex IS contended, it can cause a throughput regression of up to
90%.  That seems worth fixing.  If it turns out that lseek() is too
expensive even in the uncontended case or with the i_mutex contention
removed (or if the Linux community is unwilling to accept the proposed
fix), then we can (and should) look at further optimizing it within
PostgreSQL.  My guess, though, is that an unlocked lseek will be fast
enough that we won't need to worry about installing our own caching
infrastructure (or at least, there will be plenty of more significant
performance problems to hunt down first).

-- 
Robert Haas
EnterpriseDB: http://www.enterprisedb.com
The Enterprise PostgreSQL Company
