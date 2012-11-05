Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab2KEXx3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 18:53:29 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:63104 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320Ab2KEXx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 18:53:28 -0500
MIME-Version: 1.0
From: Matteo Croce <technoboy85@gmail.com>
Date: Tue, 6 Nov 2012 00:52:46 +0100
Message-ID: <CAFnufp3SdnBoFiC5j2bjrA=MW-WfsmFVhfggJvoHa-5ZEgg7aA@mail.gmail.com>
Subject: Kernel Source updater script
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I know that this is useless to people using git, but it was so fun to write
and I use it to update regularly my pc kernel source from time to time
while saving servers (and home) bandwidth

cheers!

#!/bin/sh

ver=$(awk '/^VERSION/{print$3}' Makefile)
patch=$(awk '/^PATCHLEVEL/{print$3}' Makefile)
sub=$(awk '/^SUBLEVEL/{print$3}' Makefile)

echo "Current kernel: $ver.$patch.$sub"

[ -d .pc ] && quilt pop -a

up_sub() {
	next=$((sub + 1))
	while wget -q --spider
http://www.kernel.org/pub/linux/kernel/v$ver.0/incr/patch-$ver.$patch.$sub-$next.xz;
do
		url="$url http://www.kernel.org/pub/linux/kernel/v$ver.0/incr/patch-$ver.$patch.$sub-$next.xz"
		sub=$next
		next=$((next + 1))
	done

	echo "Upgrading to version: $ver.$patch.$sub"

	wget -qO- $url |xz -d |patch -p1 |sed -u 's/$/
                  /' |tr '[\n]' '[\r]'
	echo
}

up_patch(){
	if [ $sub -gt 0 ]; then
		url=
		next=$((sub - 1))
		while [ $sub -gt 0 ] ; do
			if [ $next -ne 0 ]; then
				url="$url http://www.kernel.org/pub/linux/kernel/v$ver.0/incr/patch-$ver.$patch.$next-$sub.xz"
			else
				url="$url http://www.kernel.org/pub/linux/kernel/v$ver.0/patch-$ver.$patch.$sub.xz"
			fi
			sub=$next
			next=$((next - 1))
		done

		echo "Downgrading to version: $ver.$patch.$sub"

		wget -qO- $url |xz -d |patch -p1 -R |sed -u 's/$/
                      /' |tr '[\n]' '[\r]'
		echo
	fi

	url=
	patch=$((patch + 1))
	while wget -q --spider
http://www.kernel.org/pub/linux/kernel/v$ver.0/patch-$ver.$patch.xz;
do
		url="$url http://www.kernel.org/pub/linux/kernel/v$ver.0/patch-$ver.$patch.xz"
		patch=$((patch + 1))
	done
	patch=$((patch - 1))

	sub=1
	while wget -q --spider
http://www.kernel.org/pub/linux/kernel/v$ver.0/patch-$ver.$patch.$sub.xz;
do
		sub=$((sub + 1))
	done
	sub=$((sub - 1))
	url="$url http://www.kernel.org/pub/linux/kernel/v$ver.0/patch-$ver.$patch.$sub.xz"

	echo "Upgrading to version: $ver.$patch.$sub"

	wget -qO- $url |xz -d |patch -p1 |sed -u 's/$/
                  /' |tr '[\n]' '[\r]'
	echo
}

case $1 in
patch)
	up_patch
	;;

sub)
	up_sub
	;;

*)
	echo "usage: $0 [patch|sub]"
esac

[ -d .pc ] && while quilt push; do
	quilt refresh
done
