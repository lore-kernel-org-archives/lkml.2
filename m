Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843Ab0IGNk2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 09:40:28 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53477 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756381Ab0IGNkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 09:40:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=XkJ+H4+aj+D4DLKUPTRxhLdILKqtwW/FXV4XLRlMKKEB2dD2mE2FpQmEqBBUbNESFn
         oLFfIM+ERYwfNFxPgBTU4LUCBCz2LHeKkz0TJXROARHwCmByPLBWJ032jjcsjimHLt1e
         qy7uupWRSGJRs/mO6JUlQtV89ETfHBgA9Hhhk=
Date: Tue, 7 Sep 2010 17:31:07 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] base/platform: Platform data and resources NULL
 handling
Message-ID: <20100907133107.GA21463@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

There is a bug in the MFD core code (drivers/mfd/mfd-core.c),
the mfd_add_device function does not check platform_data for NULL,
and thus always calls platform_device_add_data():

static int mfd_add_device(struct device *parent, int id, [...])
{
	[...]
	ret = platform_device_add_data(pdev,
		cell->platform_data, cell->data_size);
	[...]
}

The problem is that when cell->platform_data is NULL, the platform
core calls kmemdup(NULL, 0, ...), which returns a non-NULL result
(ZERO_SIZE_PTR), and the result is stored in the dev.platform_data.
This causes drivers to oops on a valid code:

if (pdata)
	stuff = pdata->stuff;

Firstly I thought that I would fix the MFD core, but it appears
that the better approach would be to change device_add_data() call
behaviour, and thus make the core code more safe.

There are two patches: a patch that is necessary for the bug fix,
and a non-essential cleanup patch.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
