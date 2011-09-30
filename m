Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225Ab1I3X7j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 19:59:39 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:51716 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754301Ab1I3X7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 19:59:31 -0400
X-Sasl-enc: CPFy6EJ8zPna2olViwVJClvc77mAzG7+BWMuzcomJWfC 1317427170
Date: Fri, 30 Sep 2011 16:59:24 -0700
From: Greg KH <greg@kroah.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: kernel.org status: hints on how to check your machine for intrusion
Message-ID: <20110930235924.GA25176@kroah.com>
References: <4E8655CD.90107@zytor.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
Content-Disposition: inline
In-Reply-To: <4E8655CD.90107@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The compromise of kernel.org and related machines has made it clear that
some developers, at least, have had their systems penetrated.  As we
seek to secure our infrastructure, it is imperative that nobody falls
victim to the belief that it cannot happen to them.  We all need to
check our systems for intrusions.  Here are some helpful hints as
proposed by a number of developers on how to check to see if your Linux
machine might be infected with something:


0. One way to be sure that your system is not compromised is to simply
   do a clean install; we can all benefit from a new start sometimes.
   Before reinstalling any systems, though, consider following the steps
   below to learn if your system has been hit or not.

1. Install the chkrootkit package from your distro repository and see if it
   reports anything.  If your distro doesn't have the chkroot package,
   download it from:
	http://www.chkrootkit.org/

   Another tool is the ossec-rootcheck tool which can be found at:
	http://www.ossec.net/main/rootcheck

   And another one is the rkhunter program:
   	http://www.rootkit.nl/projects/rootkit_hunter.html
   [Note, this tool has the tendancy to give false-positives on some
   Debian boxes, please read /usr/share/doc/rkhunter/README.Debian.gz if
   you run this on a Debian machine]

2. Verify that your package signatures match what your package manager thinks
   they are.

   To do this on a rpm-based system, run the following command:
   	rpm --verify --all
   Please read the rpm man page for information on how to interpret the
   output of this command.

   To do this on a Debian based system, run the following bash snippet:
	dpkg -l \*|while read s n rest; do if [ "$s" == "ii" ]; then echo $n;
	fi; done > ~/tmp.txt
	for f in `cat ~/tmp.txt`; do debsums -s -a $f; done

   If you have a source-based system (Gentoo, LFS, etc.) you presumably
   know what you are doing already.

3. Verify that your packages are really signed with the distro's keys.

   Here's a bash snippet that can do this on a rpm based system to
   verify that the packages are signed with any key, not necessarily
   your distro's key.  That exercise is left for the reader:

	for package in `rpm -qa`; do
		sig=`rpm -q --qf '%{SIGPGP:pgpsig}\n' $package`
		if [ -z "$sig" ] ; then
			# check if there is a GPG key, not a PGP one
			sig=`rpm -q --qf '%{SIGGPG:pgpsig}\n' $package`
			if [ -z "$sig" ] ; then
				echo "$package does not have a signature!!!"
			fi
		fi
	done

   Unfortunately there is no known way of verifying this on Debian-based
   systems.

4. To replace a package that you find suspect, uninstall it and install
   it anew from your distro.  For example, if you want to reinstall the
   ssh daemon, you would do:
	$ /etc/init.d/sshd stop
	rpm -e openssh
	zypper install openssh	# for openSUSE based systems
	yum install openssh	# for Fedora based systems

   Ideally do this from a live cdrom boot, using the 'rpm --root' option
   to point rpm at the correct location.


5. From a liveCD environment, look for traces such as:
   a. Rogue startup scripts in /etc/rc*.d and equivalent directories.
   b. Strange directories in /usr/share that do not belong to a package.
      This can be checked on an rpm system with the following bash snippet:
	for file in `find /usr/share/`; do
		package=`rpm -qf -- ${file} | grep "is not owned"`
		if [ -n "$package" ] ; then
			echo "weird file ${file}, please check this out"
		fi
	done

6. Look for mysterious log messages, such as:
   a. Unexpected logins in wtmp and /var/log/secure*, quite possibly
      from legitimate users from unexpected hosts.
   b. Any program trying to touch /dev/mem.
   c. References to strange (non-text) ssh version strings in
      /var/log/secure*.  These do not necessarily indicate *successful*
      breakins, but they indicate *attempted* breakins which means your
      system or IP address has been targeted.

7. If any of the above steps show possible signs of compromise, you
   should investigate further and identify the actual cause.  If it
   becomes clear that the system has indeed been compromised, you should
   certainly reinstall the system from the beginning, and change your
   credentials on all machines that this machine would have had access
   to, or which you connected to through this machine.  You will need
   to check your other systems carefully, and you should almost
   certainly notify the administrators of other systems to which you
   have access.

Finally, please note that these hints are not guaranteed to turn up
signs of a compromised systems.  There are a lot of attackers out there;
some of them are rather more sophisticated than others.  You should
always be on the alert for any sort of unexpected behavior from the
systems you work with.


thanks,

greg k-h

--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEARECAAYFAk6GV9wACgkQMUfUDdst+ykaJACfei9viOT+xDX68oVC0KBOuhg6
9aIAoMphxtxhfXIwxg5F4VLnYhQnYi39
=XgHD
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--
