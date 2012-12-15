Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786Ab2LOTom (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 14:44:42 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:37285 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab2LOTol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 14:44:41 -0500
Date: Sat, 15 Dec 2012 22:43:24 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Josh Coombs <josh.coombs@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, devel@driverdev.osuosl.org,
        florian.c.schilhabel@googlemail.com,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        wlanfae@realtek.com, linux ARM <linux-arm-kernel@lists.infradead.org>,
        Larry.Finger@lwfinger.net
Subject: Re: [RFC v2 1/1] RTL8712 alignment bug in 3.6 and up on ARMV5
Message-ID: <20121215194324.GD5032@mwanda>
References: <CAMW5UfZmptBK5sLq3zMdPJ6C3Arqfyy4SY5BOPfqcOB1T-sbSg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMW5UfZmptBK5sLq3zMdPJ6C3Arqfyy4SY5BOPfqcOB1T-sbSg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for fixing this bug.  Your patch works but it's not the right
way to do it.

The original code here adds 4 to pointers which are currently
aligned instead of leaving them as is.  We have a kernel ALIGN()
macro which works correctly, but actually, it's not needed.

On arm, the pointer returned from kmalloc() is already aligned at
the 8 byte boundary because "#define ARCH_SLAB_MINALIGN 8".  The
original code always adds 4 to the pointer so everything is
misaligned.

Your patch adds another 4 bytes so it is now aligned at the 8 byte
boundary again.  That works, of course, but it's better to remove
the whole mess.

	pstapriv->pallocated_stainfo_buf = kmalloc(sizeof(struct sta_info) * NUM_STA);

Get rid of the ->pstainfo_buf pointer which is only used to store
the "aligned" version of ->pallocated_stainfo_buf.

Please send a version which applies with "git am" and has the proper
sign-off.  Sent it to yourself first.  Save the raw email (including
headers and everything).
	cat raw_email.txt | git am
Type "git log -p" to verify that the commit message looks good.
Then resend it to the list.

Thanks again.  This is a good bugfix.

regards,
dan carpenter

