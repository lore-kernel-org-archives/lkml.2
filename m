Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753636Ab0CYWA1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 18:00:27 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51607 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753337Ab0CYWAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 18:00:23 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiri Slaby <jslaby@suse.cz>
Subject: Re: [RFC 07/15] PM / Hibernate: add sws_modules_ops
Date: Thu, 25 Mar 2010 23:02:53 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc2-rjw; KDE/4.3.5; x86_64; ; )
Cc: jirislaby@gmail.com, pavel@ucw.cz, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org,
       Nigel Cunningham <ncunningham@crca.org.au>
References: <1269361063-3341-1-git-send-email-jslaby@suse.cz> <1269361063-3341-7-git-send-email-jslaby@suse.cz>
In-Reply-To: <1269361063-3341-7-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201003252302.53673.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 March 2010, Jiri Slaby wrote:
> For now they will only hold swap operations. In next patches, user
> support will be converted to ops as well to have a single layer and
> can push pages instead of pulling them.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Nigel Cunningham <ncunningham@crca.org.au>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> ---
>  kernel/power/hibernate.c |    2 +
>  kernel/power/power.h     |   13 +++++++++++
>  kernel/power/swap.c      |   51 ++++++++++++++++++++++++++++++---------------
>  3 files changed, 49 insertions(+), 17 deletions(-)
> 
> diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
> index da5288e..762431e 100644
> --- a/kernel/power/hibernate.c
> +++ b/kernel/power/hibernate.c
> @@ -34,6 +34,8 @@ dev_t swsusp_resume_device;
>  sector_t swsusp_resume_block;
>  int in_suspend __nosavedata = 0;
>  
> +struct sws_module_ops *sws_io_ops;
> +
>  enum {
>  	HIBERNATION_INVALID,
>  	HIBERNATION_PLATFORM,
> diff --git a/kernel/power/power.h b/kernel/power/power.h
> index 6c4b4fa..0f08de4 100644
> --- a/kernel/power/power.h
> +++ b/kernel/power/power.h
> @@ -115,6 +115,17 @@ struct snapshot_handle {
>   */
>  #define data_of(handle)	((handle).buffer)
>  
> +struct sws_module_ops {

I'd call that hibernate_io_ops FWIW.

> +	unsigned long (*storage_available)(void);

free_space() ?

> +
> +	int (*get_reader)(unsigned int *flags_p);
> +	int (*put_reader)(void);
> +	int (*get_writer)(void);
> +	int (*put_writer)(unsigned int flags, int error);

I agree with Pavel that these names are not exactly self-documenting.

Would it make sense to use names like reader_start(), reader_finish() and
similarly for "writer"?

> +	int (*read_page)(void *addr, struct bio **bio_chain);
> +	int (*write_page)(void *addr, struct bio **bio_chain);

Also one might think of adding a data pointer to this structure that will
be passed to the callbacks.  This way it would be easier to think of our
storage spaces as objects, each with a set of methods and a pointer to
the data they operate on.

Rafael
