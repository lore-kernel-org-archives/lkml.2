Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab2DNCeX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 22:34:23 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37738 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288Ab2DNCeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 22:34:22 -0400
Date: Sat, 14 Apr 2012 03:34:20 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Sage Weil <sage@newdream.net>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: osd_req_encode_op() breakage?
Message-ID: <20120414023420.GQ6589@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

static void osd_req_encode_op(struct ceph_osd_request *req,
                              struct ceph_osd_op *dst,
                              struct ceph_osd_req_op *src)
{
        dst->op = cpu_to_le16(src->op);

        switch (dst->op) {
        case CEPH_OSD_OP_READ:
        case CEPH_OSD_OP_WRITE:

is an interesting thing to say, seeing that CEPH_OSD_OP_READ et.al. are
all host-endian...  Should that be "switch (src->op)" instead?  AFAICS,
that sucker had appeared in that form back in
commit 68b4476b0bc13fef18266b4140309a30e86739d2
Author: Yehuda Sadeh <yehuda@hq.newdream.net>
Date:   Tue Apr 6 15:01:27 2010 -0700

    ceph: messenger and osdc changes for rbd

and it seems to be broken on big-endian hosts.  Doesn't look like a misspelled
le16_to_cpu() either, since dst->op ends up going on the wire...

I'm really mystified by that - it looks like it must've shown up immediately
on big-endian hosts; it's not like it was an obscure codepath, after all...
Comments?
