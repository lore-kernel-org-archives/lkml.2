Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758852Ab0EYQGd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 12:06:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1831 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755119Ab0EYQGc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 12:06:32 -0400
Date: Tue, 25 May 2010 17:05:50 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>, Nick Piggin <npiggin@suse.de>,
       Tejun Heo <tj@kernel.org>, Scott James Remnant <scott@ubuntu.com>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Harald Hoyer <harald@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>, agk@redhat.com,
       snitzer@redhat.com
Subject: Re: [PATCH 2/2] init, mount: export the name_to_dev_t symbol
Message-ID: <20100525160550.GC28588@agk-dp.fab.redhat.com>
Mail-Followup-To: Alasdair G Kergon <agk@redhat.com>,
	Christoph Hellwig <hch@infradead.org>,
	Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
	Al Viro <viro@zeniv.linux.org.uk>, Nick Piggin <npiggin@suse.de>,
	Tejun Heo <tj@kernel.org>, Scott James Remnant <scott@ubuntu.com>,
	Vegard Nossum <vegard.nossum@gmail.com>,
	Harald Hoyer <harald@redhat.com>,
	Christoph Lameter <cl@linux-foundation.org>, snitzer@redhat.com
References: <1274802411-26613-1-git-send-email-wad@chromium.org> <1274802411-26613-2-git-send-email-wad@chromium.org> <20100525155535.GA811@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100525155535.GA811@infradead.org>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 1TE.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 25, 2010 at 11:55:35AM -0400, Christoph Hellwig wrote:
> NACK.  It's really a hack for the boot code, there's no offical name to
> dev_t mapping.
> What are you trying to use it for?
 
Device-mapper contains a subset of that code, so he's proposing we
use it here:

@@ -434,17 +435,13 @@ static int __table_get_device(struct dm_
 	int r;
 	dev_t uninitialized_var(dev);
 	struct dm_dev_internal *dd;
-	unsigned int major, minor;
 
 	BUG_ON(!t);
 
-	if (sscanf(path, "%u:%u", &major, &minor) == 2) {
-		/* Extract the major/minor numbers */
-		dev = MKDEV(major, minor);
-		if (MAJOR(dev) != major || MINOR(dev) != minor)
-			return -EOVERFLOW;
-	} else {
-		/* convert the path to a device */
+	/* lookup by major:minor or registered device name */
+	dev = name_to_dev_t(path);
+	if (!dev) {
+		/* convert the path to a device by finding its inode */
 		struct block_device *bdev = lookup_bdev(path);
 
 		if (IS_ERR(bdev))

Alasdair

