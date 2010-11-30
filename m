Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955Ab0K3ATr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 19:19:47 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:36722 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752274Ab0K3ATp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 19:19:45 -0500
Date: Mon, 29 Nov 2010 16:19:42 -0800
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Ric Wheeler <rwheeler@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, "Theodore Ts'o" <tytso@mit.edu>,
        Neil Brown <neilb@suse.de>, Andreas Dilger <adilger.kernel@dilger.ca>,
        Alasdair G Kergon <agk@redhat.com>, Jan Kara <jack@suse.cz>,
        Mike Snitzer <snitzer@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-raid@vger.kernel.org, Keith Mannthey <kmannth@us.ibm.com>,
        dm-devel@redhat.com, Mingming Cao <cmm@us.ibm.com>,
        Tejun Heo <tj@kernel.org>, linux-ext4@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH v6 0/4] ext4: Coordinate data-only flush requests sent
	by fsync
Message-ID: <20101130001942.GF18195@tux1.beaverton.ibm.com>
Reply-To: djwong@us.ibm.com
References: <20101129220536.12401.16581.stgit@elm3b57.beaverton.ibm.com> <4CF43BC9.8040603@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CF43BC9.8040603@redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 06:48:25PM -0500, Ric Wheeler wrote:
> On 11/29/2010 05:05 PM, Darrick J. Wong wrote:
>> On certain types of hardware, issuing a write cache flush takes a considerable
>> amount of time.  Typically, these are simple storage systems with write cache
<snip>
>> lowered performance considerably, especially in the case where directio was in
>> use.  Therefore, this patch adds the coordination code directly to ext4.
>
> Hi Darrick,
>
> Just curious why we would need to have batching in both places? Doesn't 
> your patch set make the jbd2 transaction batching redundant?

The code path that I'm changing is only executed when ext4_sync_file determines
that the flush can't go through the journal, i.e. whenever the previous
sequence of data writes hasn't resulted in any metadata updates, or if the
transaction that went with the previous writes has already been committed.

> I noticed that the patches have a default delay and a mount option to 
> override that default. The jbd2 code today tries to measure the average 
> time needed in a transaction and automatically tune itself. Can't we do 
> something similar with your patch set? (I hate to see yet another mount 
> option added!)

The mount option is no longer the delay time, as it was in previous patches.
In the (unreleased) v5 patch, the code automatically tuned the delay based on
the average flush time.  However, we then observed very low flush times (< 2ms)
and about a 6% regression on our arrays with battery-backed write cache, so the
auto-tune code was then adapted in v6 to skip the coordination if the average
flush time falls below that threshold, as it does on our arrays.

Therefore, the new mount option exists to override the default threshold.

--D
