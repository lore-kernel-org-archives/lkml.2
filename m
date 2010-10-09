Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171Ab0JIWog (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 18:44:36 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:59606 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753550Ab0JIWof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 18:44:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: James Hogan <james@albanarts.com>
Subject: Re: [PATCH 1/2] pm_trace: Lock pm device list mutex.
Date: Sun, 10 Oct 2010 00:43:47 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc7-rjw+; KDE/4.4.4; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Randy Dunlap <rdunlap@xenotime.net>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        markgross <markgross@thegnar.org>
References: <201010092334.27808.james@albanarts.com> <201010092336.11548.james@albanarts.com>
In-Reply-To: <201010092336.11548.james@albanarts.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010100043.47397.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, October 10, 2010, James Hogan wrote:
> Lock the pm device list mutex using device_pm_lock() and
> device_pm_unlock() around the list iteration in show_dev_hash().
> 
> show_dev_hash() was reverse iterating dpm_list without first locking the
> mutex that the functions in drivers/base/power/main.c lock. I assume
> this was unintentional since there is no comment suggesting why the lock
> might not be necessary.
> 
> Signed-off-by: James Hogan <james@albanarts.com>

Looks good.

> ---
>  drivers/base/power/trace.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/base/power/trace.c b/drivers/base/power/trace.c
> index 0a1a2c4..17e24e3 100644
> --- a/drivers/base/power/trace.c
> +++ b/drivers/base/power/trace.c
> @@ -188,8 +188,10 @@ static int show_file_hash(unsigned int value)
>  static int show_dev_hash(unsigned int value)
>  {
>  	int match = 0;
> -	struct list_head *entry = dpm_list.prev;
> +	struct list_head *entry;
>  
> +	device_pm_lock();
> +	entry = dpm_list.prev;
>  	while (entry != &dpm_list) {
>  		struct device * dev = to_device(entry);
>  		unsigned int hash = hash_string(DEVSEED, dev_name(dev), DEVHASH);
> @@ -199,6 +201,7 @@ static int show_dev_hash(unsigned int value)
>  		}
>  		entry = entry->prev;
>  	}
> +	device_pm_unlock();
>  	return match;
>  }
>  
> 

