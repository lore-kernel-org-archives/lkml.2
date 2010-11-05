Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab0KEKb0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 06:31:26 -0400
Received: from mail1.slb.deg.dub.stisp.net ([84.203.253.98]:1549 "HELO
	mail1.slb.deg.dub.stisp.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752481Ab0KEKbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 06:31:24 -0400
X-Greylist: delayed 398 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Nov 2010 06:31:23 EDT
Message-ID: <4CD3DB5D.5040808@draigBrady.com>
Date: Fri, 05 Nov 2010 10:24:29 +0000
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Michael Tokarev <mjt@tls.msk.ru>
CC: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Detecting bind-mounts
References: <4CD31B6A.7040902@msgid.tls.msk.ru>
In-Reply-To: <4CD31B6A.7040902@msgid.tls.msk.ru>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/10 20:45, Michael Tokarev wrote:
> Hello.
> 
> There are quite some talks on the 'net - questions, not
> answers - about detecting bind mounts - be it a directory
> or a file.
> 
> There are 2 (mostly) different kinds of applications.  One
> is cp/tar/find with --same-filesystem option (or equivalent),
> that should not cross mountpoints.  And one more, apps like
> mountpoint(1) from sysvinit - a utility to determine if a
> given path is a mountpoint.
> 
> Neither of the two work when two directores on the same
> filesystem are bind-mounted.
> 
> The usual idiom is to compare st_dev of current directory and
> the parent - if they're different that's a mount point.  But
> in this case, two st_devs will be the same, so such a mount
> point will not be detected.
> 
> It is even worse for bind-mounted files (as opposed to dirs):
> there's no path/file/.. entry to stat(2), and cutting the
> last component from the pathname does not work reliable due
> to symlinks (it may be a symlink from different filesystem).
> 
> So far I know only one way to detect a bind mount like this,
> and it is unreliable anyway.  It is to parse /proc/mounts
> and try to find the object(s) in question.  Unreliable because
> of, again, symlinks, and possible complex mounts and bind-
> mounts.  And this is also very slow - imagine using this way
> for find/tar/cp --one-file-system.
> 
> Is there some simpler and more reliable way? Maybe use mount
> syscall, like we use kill($pid, 0) to check existance of a
> process?
> 
> And as far as I understand, the same applies to multiple
> mounts of the same filesystem.

The `stat` command recently got support for
printing the mount point for a file:
http://git.savannah.gnu.org/gitweb/?p=coreutils.git;a=commit;h=ddf6fb86

`stat` will output the alias for a bind mounted file
while `df` will output the initial mount point of its backing device
So you could do something like:

file=.
df_mnt=$(df -P "$file" | sed -n '2s/.* \([^ ]*$\)/\1/p')
stat_mnt=$(stat -c%m "$file")
test "$df_mnt" = "$stat_mnt" || echo "bind mount"

cheers,
Pádraig.
