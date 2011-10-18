Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932524Ab1JRPOB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 11:14:01 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:14099 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932066Ab1JRPOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 11:14:00 -0400
Date: Tue, 18 Oct 2011 17:13:49 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Greg KH <greg@kroah.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: kernel.org status: hints on how to check your machine for
 intrusion
Message-ID: <20111018171349.345f2a60@endymion.delvare>
In-Reply-To: <20110930235924.GA25176@kroah.com>
References: <4E8655CD.90107@zytor.com>
	<20110930235924.GA25176@kroah.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Yes I know I'm late, sorry about that.

On Fri, 30 Sep 2011 16:59:24 -0700, Greg KH wrote:
>    b. Strange directories in /usr/share that do not belong to a package.
>       This can be checked on an rpm system with the following bash snippet:
> 	for file in `find /usr/share/`; do
> 		package=`rpm -qf -- ${file} | grep "is not owned"`
> 		if [ -n "$package" ] ; then
> 			echo "weird file ${file}, please check this out"
> 		fi
> 	done

FWIW, the above doesn't work in the general case. For one thing it
fails for files which have a space in their name. But a bigger problem
is that rpm is localized so for any user running a non-English locale,
the grep "is not owned" will not catch anything (in addition to being
slow.) Better just check the value returned by rpm:

find /usr/share -print0 \
| while read -d $'\0' -r file
do
	if ! rpm -qf --quiet -- "${file}" ; then
		if [ -L "${file}" ] ; then
			type=link
		elif [ -d "${file}" ] ; then
			type=directory
		else
			type=file
		fi

		echo "Weird ${type} ${file}, please check this out"
	fi
done

Even with this, I'm not convinced, due to the high number of false
positives (generated cache files, directories not explicitly packaged,
etc...) it is hard to make sense of the output. We'd need to fix all
the packages first so that only actual changes are returned by the
script.

I'm also unsure why /usr/share would be a better target than any other
system directory.

-- 
Jean Delvare
