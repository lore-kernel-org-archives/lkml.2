Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147Ab1LVK3z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 05:29:55 -0500
Received: from mga07.intel.com ([143.182.124.22]:17413 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753567Ab1LVK3v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 05:29:51 -0500
MIME-Version: 1.0
In-Reply-To: <20111222091022.GO23916@ZenIV.linux.org.uk>
References: <cover.1324543719.git.dmitry.kasatkin@intel.com>
	<20111222091022.GO23916@ZenIV.linux.org.uk>
Date: Thu, 22 Dec 2011 12:29:49 +0200
Message-ID: <CALLzPKYNGbksuMNKPBr-G-YVW8by3QQfx1rudf8pwqMxs=fotA@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] vfs: truncate bug fixes
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        zohar@linux.vnet.ibm.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 11:10 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Thu, Dec 22, 2011 at 10:55:24AM +0200, Dmitry Kasatkin wrote:
>> When a file is opened with O_TRUNC or truncated with truncate()/ftruncate(),
>> and then closed, iversion is not updated. This patch uses ATTR_OPEN flag,
>> which is currently used to identify files opened with O_TRUNC,
>> as an indication to increment iversion.
>> Also it adds passing of this flag from do_sys_truncate and do_sys_ftruncate.
>> To reflect real meaning, ATTR_OPEN is suggested to be renamed to ATTR_TRUNC.
>
> Um...  Is there any difference left between that and ATTR_SIZE, then?

Oops. Indeed. It becomes simpler..

Comments and using ATTR_OPEN in fs/fuse/dir.c confused me.

update_mtime()
{
	/* If it's an open(O_TRUNC) or an ftruncate(), don't update */
	if ((ivalid & ATTR_SIZE) && (ivalid & (ATTR_OPEN | ATTR_FILE)))
}

do_sys_truncate() calls do_truncate(path.dentry, length, 0, NULL);
while do_sys_ftruncate calls do_truncate(dentry, length,
ATTR_MTIME|ATTR_CTIME, file);

Notice the last file parameter... NULL or file..

As truncate and ftruncate syscalls should do the same job as fstat or stat.
It will lead to different results for FUSE.
Following will be 0: (ivalid & (ATTR_OPEN | ATTR_FILE)

FUSE comments says.. OR
/* If it's an open(O_TRUNC) or an ftruncate(), don't update */

Will make new version..

- Dmitry
