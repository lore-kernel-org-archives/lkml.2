Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932133Ab1JMPW2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 11:22:28 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:22711 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753339Ab1JMPW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 11:22:27 -0400
Date: Thu, 13 Oct 2011 11:21:57 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, jaxboe@fusionio.com
Cc: lidongyang@novell.com, joe.jin@oracle.com, Ian.Campbell@citrix.com,
        lersek@redhat.com, jbeulich@suse.com
Subject: [GIT PULL] (xen) stable/for-jens-3.2 - blkback and blkfront patches
 for 3.2
Message-ID: <20111013152157.GA9627@phenom.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4E97022C.00A7:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Jens,

Please pull the following git tree in your 3.2 drivers tree:

 git pull git://oss.oracle.com/git/kwilk/xen.git stable/for-jens-3.2

which has a couple of bug fixes and two new features for Xen blkfront
and blkback.

The bug-fixes are the normal variety - on error path we did not the proper
thing (leak memory), on entry to some functions we did not check whether we
should just ignore the request (b/c we might not support it), and we also
forgot to increment the write sector count.

There are also two new features:
 - discard support, aka trim/unmap. We export from the backend the
   discard alignment, granularity and do normal REQ_DISCARD. We do have
   patches for the REQ_SECURE type - but not the hardware to test it so
   holding on the secure discard until I get my hands on it.

 - barrier (pre 2.6.38 kernel) support. The backend supports the FLUSH
   type operation but to support older kernels that did barriers we have
   implemented a drain technique that counts all of the bio's in flight and
   waits until they are completed and then sends a FLUSH.

In regards to testing, I've been testing this on Intel SSD, Western Digital
SSD. But sadly all of them export the block size as 512 - is there a good
SSD or disk where it would export it as something more than 512?

And here is the credit list:

Jan Beulich (1):
      xen-blkback: use kzalloc() in favor of kmalloc()+memset()

Joe Jin (1):
      xen-blkback: fixed indentation and comments

Konrad Rzeszutek Wilk (4):
      xen-blkfront: If no barrier or flush is supported, use invalid operation.
      xen/blkback: Support 'feature-barrier' aka old-style BARRIER requests.
      xen/blkback: Report VBD_WSECT (wr_sect) properly.
      xen/blkback: Fix the inhibition to map pages when discarding sector ranges.

Laszlo Ersek (1):
      xen-blkfront: plug device number leak in xlblk_init() error path

Li Dongyang (4):
      xen-blkfront: add BLKIF_OP_DISCARD and discard request struct
      xen-blkback: Implement discard requests ('feature-discard')
      xen-blkfront: Handle discard requests.
      xen-blkfront: fix a deadlock while handling discard response

The diffstat:

 drivers/block/xen-blkback/blkback.c |  130 +++++++++++++++++++++++++++++------
 drivers/block/xen-blkback/common.h  |  100 ++++++++++++++++++++++-----
 drivers/block/xen-blkback/xenbus.c  |   80 +++++++++++++++++++++-
 drivers/block/xen-blkfront.c        |  123 ++++++++++++++++++++++++++-------
 include/xen/interface/io/blkif.h    |   36 ++++++++++
 5 files changed, 403 insertions(+), 66 deletions(-)
