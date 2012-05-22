Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756132Ab2EVKXs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 06:23:48 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:47923 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751850Ab2EVKXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 06:23:46 -0400
Message-ID: <1337682220.2932.7.camel@dabdike.int.hansenpartnership.com>
Subject: Re: v3.4 will not compile
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: David Rientjes <rientjes@google.com>
Cc: James Borum <james.borum@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 22 May 2012 11:23:40 +0100
In-Reply-To: <alpine.DEB.2.00.1205212038100.13522@chino.kir.corp.google.com>
References: <CAGFGw3m_aTYv7hGYVQAajoQJ5nD7jE8iO9VdjFtQZcA72kKPew@mail.gmail.com>
	 <alpine.DEB.2.00.1205212038100.13522@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-21 at 20:39 -0700, David Rientjes wrote:
> On Mon, 21 May 2012, James Borum wrote:
> 
> > fs/built-in.o: In function `gfs2_lock':
> > file.c:(.text+0x3d7689): undefined reference to `dlm_posix_lock'
> > file.c:(.text+0x3d76c8): undefined reference to `dlm_posix_unlock'
> > file.c:(.text+0x3d76e8): undefined reference to `dlm_posix_get'
> > fs/built-in.o: In function `gdlm_cancel':
> > lock_dlm.c:(.text+0x3e9e75): undefined reference to `dlm_unlock'
> > fs/built-in.o: In function `gdlm_lock':
> > lock_dlm.c:(.text+0x3ea082): undefined reference to `dlm_lock'
> > fs/built-in.o: In function `gdlm_unmount':
> > lock_dlm.c:(.text+0x3ea60e): undefined reference to `dlm_release_lockspace'
> > fs/built-in.o: In function `control_unlock':
> > lock_dlm.c:(.text+0x3ea7dd): undefined reference to `dlm_unlock'
> > fs/built-in.o: In function `sync_lock':
> > lock_dlm.c:(.text+0x3ea920): undefined reference to `dlm_lock'
> > fs/built-in.o: In function `gdlm_put_lock':
> > lock_dlm.c:(.text+0x3eb1fc): undefined reference to `dlm_unlock'
> > fs/built-in.o: In function `gdlm_mount':
> > lock_dlm.c:(.text+0x3eb5ad): undefined reference to `dlm_new_lockspace'
> > lock_dlm.c:(.text+0x3eb869): undefined reference to `dlm_unlock'
> > lock_dlm.c:(.text+0x3eb8d1): undefined reference to `dlm_release_lockspace'
> > make: *** [.tmp_vmlinux1] Error 1
> 
> I'm suspecting you have CONFIG_DLM=m while CONFIG_GFS2_FS=y.  Seems like 
> we'll need to require CONFIG_DLM to be built-in in such a configuration?
> 
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
> diff --git a/fs/gfs2/Kconfig b/fs/gfs2/Kconfig
> --- a/fs/gfs2/Kconfig
> +++ b/fs/gfs2/Kconfig
> @@ -26,7 +26,7 @@ config GFS2_FS
>  config GFS2_FS_LOCKING_DLM
>  	bool "GFS2 DLM locking"
>  	depends on (GFS2_FS!=n) && NET && INET && (IPV6 || IPV6=n) && \
> -		HOTPLUG && DLM && CONFIGFS_FS && SYSFS
> +		HOTPLUG && (DLM=y) && CONFIGFS_FS && SYSFS

No, that's not it.  The problem is that DLM can't be a module if GFS_FS
is built in because GFS needs to use DLM functions (so DLM can be a
module as long GFS_FS is)

so this should be

&& (DLM=y || (DLM=m && GFS_FS=m))

James


