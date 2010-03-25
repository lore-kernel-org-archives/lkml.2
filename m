Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673Ab0CYWSm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 18:18:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51674 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257Ab0CYWSk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 18:18:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: what the patches do Re: [RFC 10/15] PM / Hibernate: user, implement user_ops reader
Date: Thu, 25 Mar 2010 23:21:49 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc2-rjw; KDE/4.3.5; x86_64; ; )
Cc: Jiri Slaby <jslaby@suse.cz>, jirislaby@gmail.com,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Nigel Cunningham <ncunningham@crca.org.au>
References: <1269361063-3341-1-git-send-email-jslaby@suse.cz> <1269361063-3341-10-git-send-email-jslaby@suse.cz> <20100325053003.GB12935@elf.ucw.cz>
In-Reply-To: <20100325053003.GB12935@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201003252321.49135.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 March 2010, Pavel Machek wrote:
> Hi!
> 
> > Switch /dev/snapshot reader to sws_module_ops approach so that we
> > can transparently rewrite the rest of the snapshot from pages pulling
> > to their pushing through layers.
> 
> >  struct sws_module_ops user_ops = {
> >  	.storage_available = user_storage_available,
> >  
> >  	.get_writer = get_user_writer,
> >  	.put_writer = put_user_writer,
> >  	.write_page = user_write_page,
> > +
> > +	.get_reader = get_user_reader,
> > +	.put_reader = put_user_reader,
> > +	.read_page = user_read_page,
> >  };
> 
> Ok, I guess that now I see what you are doing.... adding interface
> layer between /dev/snapshot and core hibernation code.
> 
> To recap, 2.6.33 hibernation looks like:
> 
> 			core hibernation
> 				/\
> 			       /  \
> 			swsusp	  /dev/snapshot
> 			swap            \
> 			writing      -------- read/write/ioctl interface
>                                           \
> 					 s2disk
> 
> and after your patches, we'd get
> 
> 			core hibernation
> 				/\
>                             ---------- sws_module_ops interface
> 			       /  \
> 			swsusp	  /dev/snapshot
> 			swap            \
> 			writing      -------- read/write/ioctl interface
>                                           \
> 					 s2disk
> 
> (Right? Did I understand the patches correctly?)
> 
> I have some problems with sws_module_ops interface (handcoded locking
> is too ugly to live), but it is better than I expected. But there may
> be better solution available, one that does not need two interfaces to
> maintain (we can't really get rid of userland interface). What about
> this?
> 
> 
> 
> 			core hibernation
> 				 \
> 			          \
> 			      	  /dev/snapshot
> 		                      / \
> 			           ---------- read/write/ioctl interface
>                                     /     \
> 				swsusp	 s2disk
> 				swap
> 				writing
> 
> ? That way, we have just one interface, and still keep the advantages
> of modularity / defined interfaces.
> 
> (You could literary call sys_read() from inside the kernel -- after
> set_fs() -- but going to that extreme is probably not neccessary. But
> having interface very similar to what /dev/snapshot provides -- with
> the same locking rules -- should result in better code.)

The user space interface does things that the in-kernel one doesn't really care
for, so I don't think that would be a good thing to do.  I admit it's a bit
like this right now (snapshot_[read|write]_next() do some things to satisfy
the user space interface's needs), but I don't really think it should go any
further than that.

Moreover, the Jiri's approach allows us to handle other types of storage as
well as swap using uniform interface.

Rafael
