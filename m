Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994Ab1IEJTZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 05:19:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51401 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751738Ab1IEJTT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 05:19:19 -0400
Date: Mon, 5 Sep 2011 11:19:18 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        Christoph Anton Mitterer <calestyo@scientia.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Dietsche <Gregory.Dietsche@cuw.edu>, linux-kernel@vger.kernel.org
Subject: Re: iwl4965: "MAC is in deep sleep!" freezes
Message-ID: <20110905091918.GC2221@redhat.com>
References: <bbdbd01d4965ae789384bc1f9d0a2426@imap.dd24.net>
 <20110902233806.GA22157@elie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110902233806.GA22157@elie>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

On Fri, Sep 02, 2011 at 06:38:06PM -0500, Jonathan Nieder wrote:
> Christoph Anton Mitterer wrote[1]:
> 
> > When I bring the WLAN interface up, after some time (usually just
> > minutes) I get the following error (during which the system
> > completely freezes for some 10-20s)
> [...]
> > kernel: [  951.087153] iwl4965 0000:14:00.0: Error sending REPLY_SCAN_CMD: time out after 500ms.
> > wpa_supplicant[13032]: Failed to initiate AP scan.
> > kernel: [  952.089208] ------------[ cut here ]------------
> > kernel: [  952.090089] WARNING: at drivers/net/wireless/iwlegacy/iwl-tx.c:483 iwl_legacy_enqueue_hcmd+0x3c7/0x3f0()
> 
> The warning is from v3.0-rc2~7^2~16^2~216 (iwlegacy: fix enqueue hcmd
> race conditions, 2011-04-28):
> 
> | -	spin_lock_irqsave(&priv->hcmd_lock, flags);
> | -
> | -	/* If this is a huge cmd, mark the huge flag also on the meta.flags
> | -	 * of the _original_ cmd. This is used for DMA mapping clean up.
> | -	 */
> | -	if (cmd->flags & CMD_SIZE_HUGE) {
> | -		idx = iwl_legacy_get_cmd_index(q, q->write_ptr, 0);
> | -		txq->meta[idx].flags = CMD_SIZE_HUGE;
> | -	}
> | -
> | 	idx = iwl_legacy_get_cmd_index(q, q->write_ptr, cmd->flags & CMD_SIZE_HUGE);
> | 	out_cmd = txq->cmd[idx];
> | 	out_meta = &txq->meta[idx];
> |  
> | +	if (WARN_ON(out_meta->flags & CMD_MAPPED)) {
> | +		spin_unlock_irqrestore(&priv->hcmd_lock, flags);
> | +		return -ENOSPC;
> | +	}
> | +
> 
> More details are at [1].  Stanislav, thoughts?  Is this a bug, and if
> so, any ideas for tracking it down?
It's a bug. But this looks like some different problem than is showed in
[1]

> Thanks,
> Jonathan
> 
> [1] http://bugs.debian.org/636355

Based on:
Jul 25 01:14:59 heisenberg kernel: [  121.551098] iwl4965 0000:14:00.0:
Queue 4 stuck for 2000 ms.
Jul 25 01:14:59 heisenberg kernel: [  121.555226] iwl4965 0000:14:00.0:
On demand firmware reload
Jul 25 01:15:12 heisenberg kernel: [  121.560305] iwl4965 0000:14:00.0:
MAC is in deep sleep!.  CSR_GP_CNTRL = 0x080033D8

this look like firmware hang. This happen just after module load, that's
good news, because it allow to log relative small amount debug messages
to see what possibly driver do wrong to crash firmware.

Please configure syslog to log kernel debug messages. Not sure how to do
this in debian, see  "Configure syslog to log kernel debug messages" in
https://fedoraproject.org/wiki/DebugWireless for corresponding fedora
config. Then reload driver:

modprobe -r iwl4965
echo > /var/log/kernel
modprobe iwl4965 debug=0x47ffffff

and send me /var/log/kernel including messages from iwl4965 module
load to first "MAC is in deep sleep" message.

Note this require kernel compiled with 
CONFIG_IWLWIFI_LEGACY_DEBUG=y

Thanks
Stanislaw

