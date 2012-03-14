Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030689Ab2CNGeq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 02:34:46 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:15947 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1030340Ab2CNGeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 02:34:44 -0400
X-IronPort-AV: E=Sophos;i="4.73,582,1325433600"; 
   d="scan'208";a="4531420"
Date: Wed, 14 Mar 2012 14:35:34 +0800
From: Hu Tao <hutao@cn.fujitsu.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>,
        Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH v3 2/2] virtio-scsi: add error handling
Message-ID: <20120314063534.GB1750@localhost.localdomain>
References: <1324296188-3426-1-git-send-email-pbonzini@redhat.com>
 <1324296188-3426-3-git-send-email-pbonzini@redhat.com>
 <20120310084806.GB24958@localhost.localdomain>
 <4F5C9ECF.8060803@redhat.com>
MIME-Version: 1.0
In-Reply-To: <4F5C9ECF.8060803@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-14 14:32:38,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-14 14:32:41,
	Serialize complete at 2012-03-14 14:32:41
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 11, 2012 at 01:47:11PM +0100, Paolo Bonzini wrote:
> Il 10/03/2012 09:48, Hu Tao ha scritto:
> > Is there a race here that the cmd may have been already freed (by
> > virtscsi_complete_free) after waking up from the completion?
> 
> Looks right, can you submit with a Signed-off-by?
> 

Here it is:

Fix a race in tmf path that the cmd may have been already freed
(by virtscsi_complete_free) after waking up from the completion.

Signed-off-by: Hu Tao <hutao@cn.fujitsu.com>
---
 drivers/scsi/virtio_scsi.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index 3f20678..7cba05d 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -175,7 +175,8 @@ static void virtscsi_complete_free(void *buf)
 
        if (cmd->comp)
                complete_all(cmd->comp);
-       mempool_free(cmd, virtscsi_cmd_pool);
+       else
+               mempool_free(cmd, virtscsi_cmd_pool);
 }
 
 static void virtscsi_ctrl_done(struct virtqueue *vq)
@@ -305,7 +306,7 @@ out:
 static int virtscsi_tmf(struct virtio_scsi *vscsi, struct virtio_scsi_cmd *cmd)
 {
        DECLARE_COMPLETION_ONSTACK(comp);
-       int ret;
+       int ret = SUCCESS;
 
        cmd->comp = &comp;
        ret = virtscsi_kick_cmd(vscsi, vscsi->ctrl_vq, cmd);
@@ -315,9 +316,10 @@ static int virtscsi_tmf(struct virtio_scsi *vscsi, struct virtio_scsi_cmd *cmd)
        wait_for_completion(&comp);
        if (cmd->resp.tmf.response != VIRTIO_SCSI_S_OK &&
            cmd->resp.tmf.response != VIRTIO_SCSI_S_FUNCTION_SUCCEEDED)
-               return FAILED;
+               ret = FAILED;
 
-       return SUCCESS;
+       mempool_free(cmd, virtscsi_cmd_pool);
+       return ret;
 }
 
 static int virtscsi_device_reset(struct scsi_cmnd *sc)
-- 
1.7.1

