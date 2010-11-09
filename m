Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754129Ab0KITdo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 14:33:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49435 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753671Ab0KITdj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 14:33:39 -0500
Message-ID: <4CD9A209.6070807@redhat.com>
Date: Tue, 09 Nov 2010 14:33:29 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Jeff Layton <jlayton@redhat.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        esandeen@redhat.com, jmoyer@redhat.com, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] clear PageError bit in msync & fsync
References: <20101109114422.3918e7f6@annuminas.surriel.com> <20101109142109.224267d0@corrin.poochiereds.net>
In-Reply-To: <20101109142109.224267d0@corrin.poochiereds.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2010 02:21 PM, Jeff Layton wrote:

> This does leave the page in sort of a funky state. The uptodate bit
> will still probably be set, but the dirty bit won't be. The page will
> be effectively "disconnected" from the backing store until someone
> writes to it.
>
> I suppose though that this is the best that can reasonably be done in
> this situation however...

I spent a few days looking for alternatives, and indeed I found
nothing better...

There are essentially two possibilities:
1) the VM can potentially be filled up with uncleanable dirty pages, or
2) pages that hit an IO error are left in a clean state, so they can
    be reclaimed under memory pressure

Alternative 1 could cause the entire system to deadlock, while
option 2 puts the onus on userland apps to rewrite the data
from a failed msync/fsync.

Currently the VM has behaviour #2 which is preserved with my
patch.

The only difference with my patch is, we won't keep returning
-EIO on subsequent, error free, msync or fsync calls to files
that had an IO error at some previous point in the past.

-- 
All rights reversed
