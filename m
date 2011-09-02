Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751342Ab1IBXiR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 19:38:17 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56220 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab1IBXiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 19:38:15 -0400
Date: Fri, 2 Sep 2011 18:38:06 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Christoph Anton Mitterer <calestyo@scientia.net>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Dietsche <Gregory.Dietsche@cuw.edu>, linux-kernel@vger.kernel.org
Subject: Re: iwl4965: "MAC is in deep sleep!" freezes
Message-ID: <20110902233806.GA22157@elie>
References: <bbdbd01d4965ae789384bc1f9d0a2426@imap.dd24.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bbdbd01d4965ae789384bc1f9d0a2426@imap.dd24.net>
User-Agent: Mutt/1.5.21+46 (b01d63af6fea) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Christoph Anton Mitterer wrote[1]:

> When I bring the WLAN interface up, after some time (usually just
> minutes) I get the following error (during which the system
> completely freezes for some 10-20s)
[...]
> kernel: [  951.087153] iwl4965 0000:14:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms.
> wpa_supplicant[13032]: Failed to initiate AP scan.
> kernel: [  952.089208] ------------[ cut here ]------------
> kernel: [  952.090089] WARNING: at drivers/net/wireless/iwlegacy/iwl-tx.c:483 iwl_legacy_enqueue_hcmd+0x3c7/0x3f0()

The warning is from v3.0-rc2~7^2~16^2~216 (iwlegacy: fix enqueue hcmd
race conditions, 2011-04-28):

| -	spin_lock_irqsave(&priv->hcmd_lock, flags);
| -
| -	/* If this is a huge cmd, mark the huge flag also on the meta.flags
| -	 * of the _original_ cmd. This is used for DMA mapping clean up.
| -	 */
| -	if (cmd->flags & CMD_SIZE_HUGE) {
| -		idx = iwl_legacy_get_cmd_index(q, q->write_ptr, 0);
| -		txq->meta[idx].flags = CMD_SIZE_HUGE;
| -	}
| -
| 	idx = iwl_legacy_get_cmd_index(q, q->write_ptr, cmd->flags & CMD_SIZE_HUGE);
| 	out_cmd = txq->cmd[idx];
| 	out_meta = &txq->meta[idx];
|  
| +	if (WARN_ON(out_meta->flags & CMD_MAPPED)) {
| +		spin_unlock_irqrestore(&priv->hcmd_lock, flags);
| +		return -ENOSPC;
| +	}
| +

More details are at [1].  Stanislav, thoughts?  Is this a bug, and if
so, any ideas for tracking it down?

Thanks,
Jonathan

[1] http://bugs.debian.org/636355
