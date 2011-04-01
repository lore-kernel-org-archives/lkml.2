Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520Ab1DAKNV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 06:13:21 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:43429 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755477Ab1DAKNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 06:13:20 -0400
To: Karel Zak <kzak@redhat.com>
CC: miklos@szeredi.hu, aneesh.kumar@linux.vnet.ibm.com, victor.vde@gmail.com,
        util-linux@vger.kernel.org, linuxram@us.ibm.com,
        viro@zeniv.linux.org.uk, ejmarkow@yahoo.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        lennart@poettering.net
In-reply-to: <20110401093240.GA11012@nb.net.home> (message from Karel Zak on
	Fri, 1 Apr 2011 11:32:40 +0200)
Subject: Re: [BUG] libmount misparses mountinfo on Linux v2.6.39-rc1
References: <19860.58082.277944.875401@gargle.gargle.HOWL> <87d3l62z3k.fsf@linux.vnet.ibm.com> <E1Q5ZzI-0001M4-0j@pomaz-ex.szeredi.hu> <20110401093240.GA11012@nb.net.home>
Message-Id: <E1Q5bLG-0001eG-9d@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Fri, 01 Apr 2011 12:12:34 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Apr 2011, Karel Zak wrote:
> On Fri, Apr 01, 2011 at 10:45:48AM +0200, Miklos Szeredi wrote:
> > On Fri, 01 Apr 2011, Aneesh Kumar K. V wrote:
> > > On Thu, 31 Mar 2011 22:24:01 +0200, victor.vde@gmail.com wrote:
> > > > /proc/self/mountinfo on Linux v2.6.39-rc1 includes the UUID of ext4
> > > > and ext3 mounts, for example:
> > > > 
> > > > 15 1 8:3 / / rw,noatime uuid:c645234d-9756-4d84-825e-6fe999252a34 - ext4 /dev/sda3 rw,user_xattr,acl,barrier=1,data=ordered
> > > > 
> > > > It seems the hyphens in the uuid confuse the parser
> > > > mnt_parse_mountinfo_line in tab_parse.c of libmount in util-linux.
> > > 
> > > shouldn't the parser look for " " followed by "-" followed by " " as the
> > > field seperator ? 
> > > 
> > > I am adding Miklos and Ram Pai to CC to check whether the kernel or the libmount 
> > > should be fixed ?
> > 
> > I think libmount should be fixed, though there is always the question
> > of backward compatibility.
> 
>  The parser uses
> 
> 	rc = sscanf(s,	"%u "		/* (1) id */
> 			"%u "		/* (2) parent */
> 			"%u:%u "	/* (3) maj:min */
> 			"%ms "		/* (4) mountroot */
> 			"%ms "		/* (5) target */
> 			"%ms"		/* (6) vfs options (fs-independent) */
> 			"%*[^-]"	/* (7) optional fields */

So this says, "skip everything up to the first hyphen", even though
the rule might be better expressed as "skip all space delimited words
up to the first standalone hyphen".  I guess that's not possible to
express with a scanf expression, though.

> 			"- "		/* (8) separator */
> 			"%ms "		/* (9) FS type */
> 			"%ms "		/* (10) source */
> 			"%ms",		/* (11) fs options (fs specific) */
> 
>  note that almost the same code is in systemd.
> 
> > However I don't see how the kernel could be fixed, given that libmount
> > doesn't seem to parse escape sequences (e.g. "\040" for space), which
> > it also should.
> 
>  It calls unmangle_string() for all fields, so all sequences should be
>  decoded.

Okay, so the kernel can simply escape the troublesome hyphens, which
would make the human parsing of /proc/pid/mountinfo more difficult but
at least would fix compatibility with util-linux's parser.

Thanks,
Miklos
