Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656Ab2FNKTi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 06:19:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29858 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755177Ab2FNKTh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 06:19:37 -0400
Message-ID: <4FD9BAB5.60206@redhat.com>
Date: Thu, 14 Jun 2012 12:19:33 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 2/2] msync: start async writeout when MS_ASYNC
References: <1338497035-13014-1-git-send-email-pbonzini@redhat.com> <1338497035-13014-3-git-send-email-pbonzini@redhat.com> <20120613142949.734818a8.akpm@linux-foundation.org> <4FD9A88A.8040701@redhat.com> <20120614030753.048eec9a.akpm@linux-foundation.org>
In-Reply-To: <20120614030753.048eec9a.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 14/06/2012 12:07, Andrew Morton ha scritto:
>> > If they knew it was a no-op, and relying on it, they might as well not
>> > have called it at all and save a syscall.
> Nope.  Back in the day (3+ years ago?), msync(MS_ASYNC) would flush
> pte-dirty bits into page->flags:PG_Dirty.  So it was used to make the
> filesystem aware that userspace had modified some MAP_SHARED memory. 
> The fs would then perform writeback within (typically) 30 seconds.  So
> a legitimate use would be for the app to periodically run
> msync(MS_ASYNC) to avoid having modified data floating about
> un-written-back for arbitrarily long periods.

This is in fact the same thing I would like to do in my application.
The fact that I/O is started immediately rather than within 30 seconds
is an implementation detail.

An application that calls msync(MS_ASYNC) periodically indeed wants to
start I/O _sooner or later_, it doesn't really matter when.

> Nowadays we mark the pte's read-only and take a fault on first write,
> and mark the page dirty at that time.

We mark pages dirty but we don't promise writing them back (sooner or
later we will, of course).  Otherwise there would be no need for
sync_file_range(..., SYNC_FILE_RANGE_WRITE).

Paolo
