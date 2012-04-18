Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012Ab2DRPJI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 11:09:08 -0400
Received: from mail.hq.newdream.net ([66.33.206.127]:46798 "EHLO
	mail.hq.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753852Ab2DRPJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 11:09:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=dreamhost.com; h=message-id:date
	:from:mime-version:to:cc:subject:content-type:
	content-transfer-encoding; q=dns; s=dreamhost.com; b=V9iwZQBkYbS
	7Dvbij3uCccCk/+/gwM9aouWEy87Izb3N926wwlLr7Ge3We2QliWbLN9AwJGw8/K
	uaXfIY0pjqQbA1mOx6Cg8r3VbUELb1kgz3aneXaDXBxmXN7xvXQHv0dTLXXRijFI
	oeV+I1zyGIgtiYI6z8Db1I0ZIDxG+3VY=
Message-ID: <4F8ED911.90309@dreamhost.com>
Date: Wed, 18 Apr 2012 10:09:05 -0500
From: Alex Elder <elder@dreamhost.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Sage Weil <sage@newdream.net>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: osd_req_encode_op() breakage?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I got dropped off the kernel.org lists for a bit and didn't see
this at first.  I don't know whether Sage responded to you or
not.  I'm getting back to you, just to be sure.

 > Date: Sat, 14 Apr 2012 03:34:20 +0100
 > From: Al Viro <viro@ZenIV.linux.org.uk>
 > To: Sage Weil <sage@newdream.net>
 > Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
 > Subject: osd_req_encode_op() breakage?
 >
 > static void osd_req_encode_op(struct ceph_osd_request *req,
 >                               struct ceph_osd_op *dst,
 >                               struct ceph_osd_req_op *src)
 > {
 >         dst->op = cpu_to_le16(src->op);
 >
 >         switch (dst->op) {
 >         case CEPH_OSD_OP_READ:
 >         case CEPH_OSD_OP_WRITE:
 >
 > is an interesting thing to say, seeing that CEPH_OSD_OP_READ et.al. are
 > all host-endian...  Should that be "switch (src->op)" instead?

Yes, you are absolutely correct.

We have obviously not done endianness checks in this code for
some time.

I will commit a fix and credit you for it.  I'll also make sure
we are doing proper testing for this sort of thing on a regular
basis.

					-Alex

 >  AFAICS, that sucker had appeared in that form back in
 > commit 68b4476b0bc13fef18266b4140309a30e86739d2
 > Author: Yehuda Sadeh <yehuda@hq.newdream.net>
 > Date:   Tue Apr 6 15:01:27 2010 -0700
 >
 >     ceph: messenger and osdc changes for rbd
 >
 > and it seems to be broken on big-endian hosts.  Doesn't look like a 
misspelled
 > le16_to_cpu() either, since dst->op ends up going on the wire...
 >
 > I'm really mystified by that - it looks like it must've shown up 
immediately
 > on big-endian hosts; it's not like it was an obscure codepath, after 
all...
 > Comments?
