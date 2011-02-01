Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756975Ab1BAOQe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 09:16:34 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:11060 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756911Ab1BAOQc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 09:16:32 -0500
Message-ID: <4D4815BD.5090404@parallels.com>
Date: Tue, 01 Feb 2011 17:16:29 +0300
From: Konstantin Khorenko <khorenko@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: "J. Bruce Fields" <bfields@fieldses.org>, Neil Brown <neilb@suse.de>
CC: linux-nfs@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] NFSD: memory corruption due to writing beyond the stat array
Content-Type: multipart/mixed;
 boundary="------------090602070308090607020401"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090602070308090607020401
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit

Hi All,

i've found a bug which makes NFSD to corrupt memory due to writing beyond the stat array.

Initially this issue was found on 2.6.18-x RHEL5 kernel, but the same seems to be true for the current mainstream kernel (checked on 2.6.38-rc3).

./fs/nfsd/vfs.c:
static inline struct raparms *
nfsd_get_raparms(dev_t dev, ino_t ino)
{
...
       // here we searched our file in a readahead cache
       // but not found it
...
         depth = nfsdstats.ra_size*11/10;
...
       // some stuff, but "depth" is not changed
...
         nfsdstats.ra_depth[depth*10/nfsdstats.ra_size]++;
...
}

And here we write to the 12th array element
(nfsdstats.ra_size*11/10*10/nfsdstats.ra_size == 11), while ra_depth has only
11 elements:

struct nfsd_stats {
...
        unsigned int    ra_depth[11];   /* number of times ra entry was found that deep
                                         * in the cache (10percentiles). [10] = not found */
#ifdef CONFIG_NFSD_V4
        unsigned int    nfs4_opcount[LAST_NFS4_OP + 1]; /* count of individual
nfsv4 operations */
#endif
};

This means that each time we did not find a file in a readahead cache we
corrupt memory. Fortunately in a kernel with NFSDv4 compiled in it corrupts
(inc) NFS4 ops counter, but in a kernel with NFSDv4 disabled it corrupts (inc)
some other data, that lays in the memory beyond nfsdstats.

Proposed fix is attached.

--
Best regards,

Konstantin Khorenko

--------------090602070308090607020401
Content-Type: text/plain;
 name="diff-ms-nfsd-write-beyond-stat-array"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="diff-ms-nfsd-write-beyond-stat-array"

NFSD: The patch fixes writing beyond the array.

If nfsd fails to find an exported via NFS file in the readahead cache,
it should increment corresponding nfsdstats counter (ra_depth[10]), but
due to a bug writes beside the stat array, corrupting following field.

In a kernel with NFSDv4 compiled in it corrupts (inc) NFS4 counter:
the number of individual nfsv4 operations.
In a kernel with NFSDv4 disabled it corrupts (inc) some other data,
that lays in the memory beyond nfsdstats.

Signed-off-by: Konstantin Khorenko <khorenko@openvz.org>

--- a/fs/nfsd/vfs.c.nfsd	2011-01-05 03:50:19.000000000 +0300
+++ b/fs/nfsd/vfs.c	2011-02-01 16:39:28.000000000 +0300
@@ -809,7 +809,7 @@ nfsd_get_raparms(dev_t dev, ino_t ino)
 		if (ra->p_count == 0)
 			frap = rap;
 	}
-	depth = nfsdstats.ra_size*11/10;
+	depth = nfsdstats.ra_size;
 	if (!frap) {	
 		spin_unlock(&rab->pb_lock);
 		return NULL;

--------------090602070308090607020401--
