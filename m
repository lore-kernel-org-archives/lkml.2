Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933007Ab2JSVjN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 17:39:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41157 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932149Ab2JSVjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 17:39:11 -0400
Date: Fri, 19 Oct 2012 22:39:05 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk
Message-ID: <20121019213904.GB13292@decadent.org.uk>
References: <20121019024255.944999470@linuxfoundation.org>
 <20121019024301.172251728@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121019024301.172251728@linuxfoundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [ 32/62] kdb,vt_console: Fix missed data due to pager overruns
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 07:45:00PM -0700, Greg Kroah-Hartman wrote:
> 3.4-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Jason Wessel <jason.wessel@windriver.com>
> 
> commit 17b572e82032bc246324ce136696656b66d4e3f1 upstream.
[...]
> This also means that the vt screen needs to set the kdb COLUMNS
> variable.
[...]
> --- a/drivers/tty/vt/vt.c
> +++ b/drivers/tty/vt/vt.c
> @@ -3475,6 +3475,19 @@ int con_debug_enter(struct vc_data *vc)
>  			kdb_set(2, setargs);
>  		}
>  	}
> +	if (vc->vc_cols < 999) {
> +		int colcount;
> +		char cols[4];
> +		const char *setargs[3] = {
> +			"set",
> +			"COLUMNS",
> +			cols,
> +		};
> +		if (kdbgetintenv(setargs[0], &colcount)) {
> +			snprintf(cols, 4, "%i", vc->vc_cols);
> +			kdb_set(2, setargs);
> +		}
> +	}

Presumably the idea here was to avoid overriding the 'COLUMNS'
variable if it is already set, but it's actually testing whether the
variable 'set' is set.  (Besides which, there should be a kdbsetenv()
instead of this gross hack of faking up a user command.  And whyever
did kdb have to make argc off-by-one from the usual C convention?)

[...]
> +	if (KDB_STATE(PAGER)) {
> +		/*
> +		 * Check printed string to decide how to bump the
> +		 * kdb_nextline to control when the more prompt should
> +		 * show up.
> +		 */
> +		int got = 0;
> +		len = retlen;
> +		while (len--) {
> +			if (kdb_buffer[len] == '\n') {
> +				kdb_nextline++;
> +				got = 0;
> +			} else if (kdb_buffer[len] == '\r') {
> +				got = 0;
> +			} else {
> +				got++;
> +			}
> +		}
> +		kdb_nextline += got / (colcount + 1);

What if more than one logical line is wrapped?
Why divide by colcount + 1?  Shouldn't it be (got - 1) / colcount?
 
Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus
