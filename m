Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570Ab1DAKia (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 06:38:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13500 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754266Ab1DAKi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 06:38:29 -0400
Date: Fri, 1 Apr 2011 12:38:17 +0200
From: Karel Zak <kzak@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: aneesh.kumar@linux.vnet.ibm.com, victor.vde@gmail.com,
        util-linux@vger.kernel.org, linuxram@us.ibm.com,
        viro@zeniv.linux.org.uk, ejmarkow@yahoo.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        lennart@poettering.net
Subject: Re: [BUG] libmount misparses mountinfo on Linux v2.6.39-rc1
Message-ID: <20110401103817.GB11012@nb.net.home>
References: <19860.58082.277944.875401@gargle.gargle.HOWL> <87d3l62z3k.fsf@linux.vnet.ibm.com> <E1Q5ZzI-0001M4-0j@pomaz-ex.szeredi.hu> <20110401093240.GA11012@nb.net.home> <E1Q5bLG-0001eG-9d@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Q5bLG-0001eG-9d@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 01, 2011 at 12:12:34PM +0200, Miklos Szeredi wrote:
> On Fri, 1 Apr 2011, Karel Zak wrote:
> > On Fri, Apr 01, 2011 at 10:45:48AM +0200, Miklos Szeredi wrote:
> > > On Fri, 01 Apr 2011, Aneesh Kumar K. V wrote:
> > > > On Thu, 31 Mar 2011 22:24:01 +0200, victor.vde@gmail.com wrote:
> > > > > /proc/self/mountinfo on Linux v2.6.39-rc1 includes the UUID of ext4
> > > > > and ext3 mounts, for example:
> > > > > 
> > > > > 15 1 8:3 / / rw,noatime uuid:c645234d-9756-4d84-825e-6fe999252a34 - ext4 /dev/sda3 rw,user_xattr,acl,barrier=1,data=ordered
> > > > > 
> > > > > It seems the hyphens in the uuid confuse the parser
> > > > > mnt_parse_mountinfo_line in tab_parse.c of libmount in util-linux.
> > > > 
> > > > shouldn't the parser look for " " followed by "-" followed by " " as the
> > > > field seperator ? 
> > > > 
> > > > I am adding Miklos and Ram Pai to CC to check whether the kernel or the libmount 
> > > > should be fixed ?
> > > 
> > > I think libmount should be fixed, though there is always the question
> > > of backward compatibility.
> > 
> >  The parser uses
> > 
> > 	rc = sscanf(s,	"%u "		/* (1) id */
> > 			"%u "		/* (2) parent */
> > 			"%u:%u "	/* (3) maj:min */
> > 			"%ms "		/* (4) mountroot */
> > 			"%ms "		/* (5) target */
> > 			"%ms"		/* (6) vfs options (fs-independent) */
> > 			"%*[^-]"	/* (7) optional fields */
> 
> So this says, "skip everything up to the first hyphen", even though
> the rule might be better expressed as "skip all space delimited words
> up to the first standalone hyphen".  I guess that's not possible to
> express with a scanf expression, though.

 Yes, I'll probably use two sscanf(), %n and strstr(), something like:

	rc = sscanf(s,	"%u "		/* (1) id */
			"%u "		/* (2) parent */
			"%u:%u "	/* (3) maj:min */
			"%ms "		/* (4) mountroot */
			"%ms "		/* (5) target */
			"%ms"		/* (6) vfs options (fs-independent) */
			"%n",

			&id,
			&parent,
			&maj, &min,
			&root,
			&target,
			&vfs_optstr,
			&end);

	s += end;

	/* (7) optional fields, terminated by " - " */
	p = strstr(s, " - ");
	if (p)
		s = p + 3;

	rc += sscanf(s,	"%ms "		/* (8) FS type */
			"%ms "		/* (9) source */
			"%ms",		/* (10) fs options (fs specific) */

			&fstype,
			&src,
			&fs_optstr);


...or anyone has a better idea?

> >  It calls unmangle_string() for all fields, so all sequences should be
> >  decoded.
> 
> Okay, so the kernel can simply escape the troublesome hyphens, which
> would make the human parsing of /proc/pid/mountinfo more difficult but
> at least would fix compatibility with util-linux's parser.

Hmm.. IMHO it will be better to fix the parsers in libmount and systemd. The 
both projects are young, nobody will be surprised with bugs :-)

I think the example in Documentation/filesystems/proc.txt is pretty
obvious, the separator is an extra field with " - ".

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
