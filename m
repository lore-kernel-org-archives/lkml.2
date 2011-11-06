Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753199Ab1KFVsg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 16:48:36 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.121]:62687 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab1KFVsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 16:48:35 -0500
X-Authority-Analysis: v=2.0 cv=YYg/Fntf c=1 sm=0 a=QETZmXXmyubuBiJjAgCHWw==:17 a=y8ZX_BOJfaUA:10 a=8nJEP1OIZ-IA:10 a=xe8BsctaAAAA:8 a=OqLjXh8zMRUUj2EWYRkA:9 a=wPNLvfGTeEIA:10 a=QETZmXXmyubuBiJjAgCHWw==:117
X-Cloudmark-Score: 0
X-Originating-IP: 97.103.252.48
Message-ID: <4EB700B1.3050205@cfl.rr.com>
Date: Sun, 06 Nov 2011 16:48:33 -0500
From: Phillip Susi <psusi@cfl.rr.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: write_cache_pages inefficiency
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I've read over write_cache_pages() in page-writeback.c, and related
writepages() functions, and it seems to me that it suffers from a
performance problem whenever an fsync is done on a file and some of
its pages have already begun writeback.  The comment in the code says:

 * If a page is already under I/O, write_cache_pages() skips it, even
 * if it's dirty.  This is desirable behaviour for memory-cleaning
writeback,
 * but it is INCORRECT for data-integrity system calls such as
fsync().  fsync()
 * and msync() need to guarantee that all the data which was dirty at
the time
 * the call was made get new I/O started against them.  If
wbc->sync_mode is
 * WB_SYNC_ALL then we were called for data integrity and we must wait for
 * existing IO to complete.

Based on this, I would expect the function to wait for an existing
write to complete only if the page is also dirty.  Instead, it waits
for existing page writes to complete regardless of the dirty bit.
Additionally, it does each wait serially, so if you are trying to
fsync 1000 dirty pages, and the first 10 are already being written
out, the thread will block on each of those 10 pages write completion
before it begins queuing any new writes.

Instead, shouldn't it go ahead and initiate pagewrite on all pages not
already being written, and then come back and wait on those that were
already in flight to complete, then initiate a second write on them if
they are dirty?
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk63ALEACgkQJ4UciIs+XuL/NgCfXBftM2PRN10u0i3DBG94hny6
dVoAoKbQp3yiY6ZotjbqHyd+kOEXiLgf
=dK4Q
-----END PGP SIGNATURE-----
