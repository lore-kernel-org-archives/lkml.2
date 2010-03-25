Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752254Ab0CYFaO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 01:30:14 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:56635 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750967Ab0CYFaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 01:30:12 -0400
Date: Thu, 25 Mar 2010 06:30:03 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Jiri Slaby <jslaby@suse.cz>
Cc: jirislaby@gmail.com, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org,
       Nigel Cunningham <ncunningham@crca.org.au>,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: what the patches do Re: [RFC 10/15] PM / Hibernate: user,
 implement user_ops reader
Message-ID: <20100325053003.GB12935@elf.ucw.cz>
References: <1269361063-3341-1-git-send-email-jslaby@suse.cz>
 <1269361063-3341-10-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269361063-3341-10-git-send-email-jslaby@suse.cz>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> Switch /dev/snapshot reader to sws_module_ops approach so that we
> can transparently rewrite the rest of the snapshot from pages pulling
> to their pushing through layers.

>  struct sws_module_ops user_ops = {
>  	.storage_available = user_storage_available,
>  
>  	.get_writer = get_user_writer,
>  	.put_writer = put_user_writer,
>  	.write_page = user_write_page,
> +
> +	.get_reader = get_user_reader,
> +	.put_reader = put_user_reader,
> +	.read_page = user_read_page,
>  };

Ok, I guess that now I see what you are doing.... adding interface
layer between /dev/snapshot and core hibernation code.

To recap, 2.6.33 hibernation looks like:

			core hibernation
				/\
			       /  \
			swsusp	  /dev/snapshot
			swap            \
			writing      -------- read/write/ioctl interface
                                          \
					 s2disk

and after your patches, we'd get

			core hibernation
				/\
                            ---------- sws_module_ops interface
			       /  \
			swsusp	  /dev/snapshot
			swap            \
			writing      -------- read/write/ioctl interface
                                          \
					 s2disk

(Right? Did I understand the patches correctly?)

I have some problems with sws_module_ops interface (handcoded locking
is too ugly to live), but it is better than I expected. But there may
be better solution available, one that does not need two interfaces to
maintain (we can't really get rid of userland interface). What about
this?



			core hibernation
				 \
			          \
			      	  /dev/snapshot
		                      / \
			           ---------- read/write/ioctl interface
                                    /     \
				swsusp	 s2disk
				swap
				writing

? That way, we have just one interface, and still keep the advantages
of modularity / defined interfaces.

(You could literary call sys_read() from inside the kernel -- after
set_fs() -- but going to that extreme is probably not neccessary. But
having interface very similar to what /dev/snapshot provides -- with
the same locking rules -- should result in better code.)

									Pavel 

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
