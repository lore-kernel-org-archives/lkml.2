Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946742Ab2ERXHH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 19:07:07 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:35668 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946720Ab2ERXGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 19:06:53 -0400
Message-Id: <20120518212651.944059391@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 18 May 2012 14:27:19 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ben Marzinski <bmarzins@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Subject: [ 30/47] dm mpath: check if scsi_dh module already loaded before trying to load
In-Reply-To: <20120518212701.GA5023@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Snitzer <snitzer@redhat.com>

commit 510193a2d3d2e03ae53b95c0ae4f33cdff02cbf8 upstream.

If the requested scsi_dh module is already loaded then skip
request_module().

Multipath table loads can hang in an unnecessary __request_module.

Reported-by: Ben Marzinski <bmarzins@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/dm-mpath.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -698,8 +698,8 @@ static int parse_hw_handler(struct dm_ar
 		return 0;
 
 	m->hw_handler_name = kstrdup(dm_shift_arg(as), GFP_KERNEL);
-	request_module("scsi_dh_%s", m->hw_handler_name);
-	if (scsi_dh_handler_exist(m->hw_handler_name) == 0) {
+	if (!try_then_request_module(scsi_dh_handler_exist(m->hw_handler_name),
+				     "scsi_dh_%s", m->hw_handler_name)) {
 		ti->error = "unknown hardware handler type";
 		ret = -EINVAL;
 		goto fail;


