Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837Ab2CWWsg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 18:48:36 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:60912 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754148Ab2CWWsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 18:48:35 -0400
Message-ID: <4F6CFDBF.9060404@xenotime.net>
Date: Fri, 23 Mar 2012 15:48:31 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Benjamin Poirier <bpoirier@suse.de>
CC: David Teigland <teigland@redhat.com>,
        Steven Whitehouse <swhiteho@redhat.com>, linux-kernel@vger.kernel.org,
        cluster-devel@redhat.com
Subject: Re: GFS2: Pre-pull patch posting (merge window)
References: <1332152728-4027-1-git-send-email-swhiteho@redhat.com> <4F674696.7030602@xenotime.net> <1332169153.2689.20.camel@menhir> <4F674E4F.5080904@xenotime.net> <1332171247.2689.28.camel@menhir> <20120323194152.GD24746@redhat.com> <4F6CD7AD.9030306@xenotime.net> <20120323201820.GE24746@redhat.com> <20120323220618.GA30906@d2.synalogic.ca>
In-Reply-To: <20120323220618.GA30906@d2.synalogic.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2012 03:06 PM, Benjamin Poirier wrote:

> On 2012/03/23 16:18, David Teigland wrote:
>> On Fri, Mar 23, 2012 at 01:06:05PM -0700, Randy Dunlap wrote:
>>>>> GFS2_FS selects DLM (if GFS2_FS_LOCKING_DLM, which is enabled).
>>>>> GFS2_FS selects IP_SCTP if DLM_SCTP, which is not enabled and not
>>>>> used anywhere else in the kernel tree AFAICT.
>>>>> DLM just always selects IP_SCTP.
>>>>
>>>> Here's what we have now:
>>>>
>>>> config GFS2_FS
>>>>         tristate "GFS2 file system support"
>>>>         depends on (64BIT || LBDAF)
>>>>         select DLM if GFS2_FS_LOCKING_DLM
>>>>         select CONFIGFS_FS if GFS2_FS_LOCKING_DLM
>>>>         select SYSFS if GFS2_FS_LOCKING_DLM
>>>>         select IP_SCTP if DLM_SCTP
>>>>         select FS_POSIX_ACL
>>>>         select CRC32
>>>>         select QUOTACTL
>>>>
>>>> menuconfig DLM
>>>>         tristate "Distributed Lock Manager (DLM)"
>>>>         depends on EXPERIMENTAL && INET
>>>>         depends on SYSFS && CONFIGFS_FS && (IPV6 || IPV6=n)
>>>>         select IP_SCTP
>>>>
>>>> Why does gfs2 Kconfig bother with SCTP at all?  It seems that line should
>>>> just be removed.  I'll also remove EXPERIMENTAL.  I don't understand the
>>>> vagaries of Kconfig, so a dumb question, how could sctp_do_peeloff
>>>> possibly be undefined if we're selecting SCTP.
>>>
>>> What is selecting SCTP?  DLM?  so GFS2 selects DLM, but selects
>>> don't follow dependency chains.  Also, the "select IP_SCTP if DLM_SCTP"
>>> in GFS2 is meaningless since there is no DLM_SCTP.
>>
>> https://lkml.org/lkml/2012/3/8/222 seems to have caused this by adding
>> the new dependency on the sctp module without any Kconfig changes.
>>
>> Should that patch have added depends IP_SCTP to the dlm and gfs2?
>>
> 
> Instead of trying to select everything in GFS2, how about doing it this way?
> 
> [PATCH] gfs2: use depends instead of select in kconfig
> 
> Avoids having to duplicate the dependencies of what is 'select'ed (and on
> down...)
> 
> Those dependencies are currently incomplete, leading to broken builds with
> GFS2_FS_LOCKING_DLM=y and IP_SCTP=n.
> 
> Signed-off-by: Benjamin Poirier <bpoirier@suse.de>


That seems to work for me.  Thanks.

Acked-by: Randy Dunlap <rdunlap@xenotime.net>


> ---
>  fs/gfs2/Kconfig |    7 ++-----
>  1 files changed, 2 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/gfs2/Kconfig b/fs/gfs2/Kconfig
> index c465ae0..eb08c9e 100644
> --- a/fs/gfs2/Kconfig
> +++ b/fs/gfs2/Kconfig
> @@ -1,10 +1,6 @@
>  config GFS2_FS
>  	tristate "GFS2 file system support"
>  	depends on (64BIT || LBDAF)
> -	select DLM if GFS2_FS_LOCKING_DLM
> -	select CONFIGFS_FS if GFS2_FS_LOCKING_DLM
> -	select SYSFS if GFS2_FS_LOCKING_DLM
> -	select IP_SCTP if DLM_SCTP
>  	select FS_POSIX_ACL
>  	select CRC32
>  	select QUOTACTL
> @@ -29,7 +25,8 @@ config GFS2_FS
>  
>  config GFS2_FS_LOCKING_DLM
>  	bool "GFS2 DLM locking"
> -	depends on (GFS2_FS!=n) && NET && INET && (IPV6 || IPV6=n) && HOTPLUG
> +	depends on (GFS2_FS!=n) && NET && INET && (IPV6 || IPV6=n) && \
> +		HOTPLUG && DLM && CONFIGFS_FS && SYSFS
>  	help
>  	  Multiple node locking module for GFS2
>  



-- 
~Randy
