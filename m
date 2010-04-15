Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139Ab0DOXua (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 19:50:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:65445 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757945Ab0DOXu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 19:50:28 -0400
Date: Thu, 15 Apr 2010 16:49:15 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Jeff Mahoney <jeffm@suse.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>,
       Edward Shishkin <edward.shishkin@gmail.com>, stable@kernel.org,
       kernel@jbeekman.nl, gregsurbey@hotmail.com,
       Marco Gatti <marco.gatti@gmail.com>
Subject: Re: [PATCH] reiserfs: Fix corruption during shrinking of xattrs
In-Reply-To: <alpine.DEB.2.01.1004140127090.29272@bogon.housecafe.de>
Message-ID: <alpine.DEB.2.01.1004151632110.4069@bogon.housecafe.de>
References: <4BC4C888.9040104@suse.com> <alpine.DEB.2.01.1004140127090.29272@bogon.housecafe.de>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1/8l06cGhQenj64fY8GL8GLlQ13yOqi0jV4B7R
 gINrh2ia5003HXwylmVFhUZgPS4SAym0ukZC6pyzF7a5G4qRHW
 2vkRw1DjFQg37b8fLVtIg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Apr 2010 at 01:32, Christian Kujau wrote:
> On Tue, 13 Apr 2010 at 15:39, Jeff Mahoney wrote:
> >  This patch fixes it to use new_size.
> 
> Tested-by: Christian Kujau <lists@nerdbynature.de>

Dang. While this *does* seem to fix the "Input/output error after a large 
amount of files have their xattrs removed", it does not fix the initial 
issue in #14826, where occasionally this jdm-20002 message shows up.

I just tested this: I still have this calendarserver (caldavd) and it's 
heavily using xattr. I have removed everything under /var/spool/caldavd, 
started caldavd and am now importing a calendar. caldavd will now create 
files under /var/spool/caldavd, wil assign xattrs and read them. And just 
after a few operations, this happens again:

[138794.184926] REISERFS warning (device xvda3): jdm-20002 
reiserfs_xattr_get: Invalid hash for xattr 
(user.{http:%2F%2Ftwistedmatrix.com%2Fxml_namespace%2Fdav%2Fprivate%2F}quota-used) 
associated with [765 3282 0x0 SD]

[139238.740552] REISERFS warning (device xvda3): jdm-20002 
reiserfs_xattr_get: Invalid hash for xattr (user.{DAV:}displayname) 
associated with [765 3402 0x0 SD]

Inodes 3282, 3402, aka

./calendars/__uids__/afebe2f1-f51a-5859-af15-f22312ad6634
./calendars/__uids__/afebe2f1-f51a-5859-af15-f22312ad6634/2CC21268-C87E-4AE6-AFD4-33946D5621AB

....under /var/spool/caldavd. So it does happen for new files 
(directories in this case) indeed.

However, there's no file corruption, no I/O errors - I can still access 
the directory and its contents. The xattr information might be lost 
though. Bug #14826 somehow transformed into "my filesystem is corrupt", as 
the bug with the large amount of files/xattr seems to generate the same 
message in the syslog. But that's a different issue, methinks.

Christian.

[0] https://bugzilla.kernel.org/show_bug.cgi?id=14826
-- 
BOFH excuse #124:


user to computer ration too low.
