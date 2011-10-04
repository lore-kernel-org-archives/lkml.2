Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933612Ab1JDUFw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 16:05:52 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:44955 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933403Ab1JDUFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 16:05:51 -0400
Date: Tue, 4 Oct 2011 23:05:45 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: linux-kernel@vger.kernel.org
Subject: NULL dereference in tty_open()
Message-ID: <20111004200544.GA21192@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090208.4E8B671E.007C,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a NULL dereference here.  It was artificially triggered so
not a huge priority.

drivers/tty/tty_io.c
  1893          retval = tty_add_file(tty, filp);
  1894          if (retval) {
  1895                  tty_unlock();
  1896                  tty_release(inode, filp);
  1897                  return retval;
  1898          }

tty_add_file() is supposed to setup filp->private_data but the
allocation fails.  In tty_release() we call file_tty(filp),
__tty_fasync() and tty_del_file() which dereference
filp->private_data and Oops.

I looked at ptmx_open() to see how the error handling was done there.
That function only calls tty_release() if tty_add_file() succeeds,
so maybe we could just call devpts_kill_index() here and remove the
tty_release()?  I don't know the code well enough to say.

regards,
dan carpenter
