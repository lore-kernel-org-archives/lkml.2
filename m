Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833Ab2CHH27 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 02:28:59 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55980 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab2CHH25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 02:28:57 -0500
Date: Thu, 8 Mar 2012 15:34:13 +0800
From: Zheng Liu <gnehzuil.liu@gmail.com>
To: linux-mm <linux-mm@kvack.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: Control page reclaim granularity
Message-ID: <20120308073412.GA6975@gmail.com>
Mail-Followup-To: linux-mm <linux-mm@kvack.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Konstantin Khlebnikov <khlebnikov@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

Recently we encounter a problem about page reclaim.  I abstract it in here.
The problem is that there are two different file types.  One is small index
file, and another is large data file.  The index file is mmaped into memory,
and application hope that they can be kept in memory and don't be reclaimed
too frequently.  The data file is manipulted by read/write, and they should
be reclaimed more frequently than the index file.

As previously discussion [1], Konstantin suggest me to mmap index file with
PROT_EXEC flag.  Meanwhile he provides a patch to set a flag in mm_flags to
increase the priority of mmaped file pages.  However, these solutions are
not perfect.  I review the related patches (8cab4754 and c909e993) and I
think that mmaped index file with PROT_EXEC flag is too tricky.  From the
view of applicaton programmer, index file is a regular file that stores
some data.  So they should be mmap with PROT_READ | PROT_WRITE rather than
with PROT_EXEC.  As commit log said (8cab4754), the purpose of this patch
is to keep executable code in memory to improve the response of application.
In addition, Kongstantin's patch needs to adjust the application program.
So in some cases, we cannot touch the code of application, and this patch is
useless.

I have discussed with Kongstantin about this problem and we think maybe
kernel should provide some mechanism.  For example, user can set memory
pressure priorities for vma or inode, or mmaped pages and file pages can be
reclaimed separately.  If someone has thought about it, please let me know.
Any feedbacks are welcomed.  Thank you.

Previously discussion:
1. http://marc.info/?l=linux-mm&m=132947026019538&w=2

Regards,
Zheng
