Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756382Ab2LNPVE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 10:21:04 -0500
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:59898 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756322Ab2LNPU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 10:20:59 -0500
Date: Fri, 14 Dec 2012 15:26:07 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        containers@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        linux-security-module@vger.kernel.org
Subject: Re: [RFC][PATCH] Fix cap_capable to only allow owners in the
 parent user namespace to have caps.
Message-ID: <20121214152607.GA9266@mail.hallyn.com>
References: <87ip88uw4n.fsf@xmission.com>
 <50CA2B55.5070402@amacapital.net>
 <87mwxhtxve.fsf@xmission.com>
 <87zk1hshk7.fsf_-_@xmission.com>
 <20121214032820.GA5115@mail.hallyn.com>
 <87bodxi9zw.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bodxi9zw.fsf@xmission.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> "Serge E. Hallyn" <serge@hallyn.com> writes:
> 
> > Quoting Eric W. Biederman (ebiederm@xmission.com):
> >> 
> >> Andy Lutomirski pointed out that the current behavior of allowing the
> >> owner of a user namespace to have all caps when that owner is not in a
> >> parent user namespace is wrong.
> >
> > To make sure I understand right, the issue is when a uid is mapped
> > into multiple namespaces.
> 
> Yes.
> 
> i.e. uid 1000 in ns1 may own ns2, but uid 1000 in ns3 does not?
> 
> I am not certain of your example.
> 
> The simple case is:
> 
> init_user_ns:
>      child_user_ns1 (owned by uid == 0 [in all user namespaces])
>            child_user_ns2 (owned by uid == 0 [ in all user namespaces])
> 
> 
> root (uid == 0) in child_user_ns2 has all rights over anything in
> child_user_ns1.

Well that is only if there was no mapping.  (since we're comparing
kuids, not uid_ts).  right?  If you didn't map uid 0 in child_user_ns2
to another id in the parent ns, you weren't all *that* serious about
isolating the ns.

The case I was thinking is

  init_user_ns:  [0-uidmax]
      child_user_ns1  [100000-199999]
      child_user_ns2  [100000-199999]
        child_user_ns3  [200000-299999]

with unfortunate mappings  - ns1 and ns2 should have had nonoverlapping
ranges, but in any case now uid 1000 in ns1 can exert privilege over
ns3.  Again, uids comparisons will succeed for file access anyway, so
ns1 can 0wn ns2 and ns3 other ways.

Heck I'm starting to think the bug is a feature - surely given the
mappings above I meant for ns1 and ns2 to bleed privilege to each
other?

> Thank you for looking.
> 
> Eric
