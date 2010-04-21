Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab0DUPJS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 11:09:18 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:54562 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754018Ab0DUPJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 11:09:16 -0400
Date: Wed, 21 Apr 2010 10:09:00 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: lkml <linux-kernel@vger.kernel.org>, David Howells <dhowells@redhat.com>,
       Ashwin Ganti <ashwin.ganti@gmail.com>, Greg KH <greg@kroah.com>,
       rsc@swtch.com, ericvh@gmail.com, linux-security-module@vger.kernel.org,
       Ron Minnich <rminnich@gmail.com>, jt.beard@gmail.com,
       Andrew Morton <akpm@linux-foundation.org>,
       Andrew Morgan <morgan@kernel.org>, oleg@us.ibm.com,
       Eric Paris <eparis@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>, linux-api@vger.kernel.org,
       Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 3/3] p9auth: add p9auth driver
Message-ID: <20100421150900.GB31880@us.ibm.com>
References: <20100421012749.GA21338@us.ibm.com>
 <20100421012908.GB24251@us.ibm.com>
 <20100421102739.6ad932fb@lxorguk.ukuu.org.uk>
 <20100421133917.GB16326@us.ibm.com>
 <20100421151917.5ae20265@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100421151917.5ae20265@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Alan Cox (alan@lxorguk.ukuu.org.uk):
> > sorry I thought I had cc:d you, bc I was pretty sure you'd have some
> > neat ideas.  Like this one.
> > 
> > One could try to argue that this makes every linux process susceptible
> > to a trojan making it grant its userid to other tasks, but of course
> > that's silly since the trojan could just fork.  Well, what this would
> > buy the attacker is the ability to sit inconspicuously under his old
> > userid, holding on to the fd until the admin goes out to coffee before
> > switching userids.
> 
> Possibly, could you put a timestamp in the passed object ? (Given the
> expiry of such a uid offer is kind of policy)

Yup, in fact I do that for the p9auth device driver anyway, to avoid
letting a user take up all kernel memory with unused setuid tokens.

> > The other thing is that offhand I think the server can't easily tell
> > from the socket which user namespace the client is in, as ucred only
> > has .uid.  Though (1) we might need to create a 'struct puser' analogous
> > to 'struct pid' for signals anyway, (2) userspace can segragate with
> > fs or net_ns (if abstract sock), and (3) client in a container
> > presumably won't be able to authenticate itself to server on the
> > host anyway.
> 
> That I think needs fixing anyway and now is a good time as any to do it.
> If you are going to be able to pass userids then you need to be sure you
> don't get passed a handle with a uid change on it that you didn't want so
> adding another object type and option of some kind to accept them has to
> occur anyway.

Ignoring namespaces for a moment, I guess we could do something like

struct credentials_pass {
	pid_t global_pid;
	unsigned long unique_id;
	uid_t new_uid;
	gid_t new_gid;
	int num_aux_gids;
	gid_t aux_gids[];
}

The unique_id is assigned by the kernel;  the client reads the whole
struct credentials_pass - except global_pid - from the unix sock,
verifies the desired credentials, then does sys_acceptid(unique_id)
to accept.

Again, how to pass user namespace information is not obvious to me.

And it's probably debatable whether we want to also pass info about
posix capabilities and LSM security data.

Still, my main concern with this approach is that it makes the server
more complicated.  Since I'm passing along my current credentials, that
means I have to construct just the right credentials, which if using
sock identified by pathname may mean I can no longer write to the
socket, right?

And of course one other important consideration is that the overall
p9auth API has been heavily discussed and documented, whereas
implementing our own entirely new approach is breaking new ground
and therefore a lot scarier.

> That also btw needs fixing for other reasons - more than one daemon has
> been written that generically uses recvmsg and so can be attacked with FD
> leaks >-)

Yup.

(By 'needs fixing' you just mean needs to be done right for this
service?  Else I think I'm missing something...)

thanks,
-serge
