Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab1FEGFa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 02:05:30 -0400
Received: from home.keithp.com ([63.227.221.253]:47231 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752746Ab1FEGF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 02:05:29 -0400
From: "Keith Packard" <keithp@keithp.com>
To: dri-devel@lists.freedesktop.org
Subject: drivers/drm/i915 maintenance process
User-Agent: Notmuch/0.5-202-g6ae4e7d (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
cc: "drivers, Intel" <Intel-gfx@lists.freedesktop.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Sat, 04 Jun 2011 23:05:23 -0700
Message-ID: <yunipskolss.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable


I'm trying to formalize the process for merging code into the drm/i915
driver. Here's a first draft, please send along your comments.

=2Dkeith

Right now, I'm merging patches destined for the 3.0 release
in a kernel.org tree:

git://git.kernel.org/pub/scm/linux/kernel/git/keithp/linux-2.6.git

(yes, I need to fix the name, I'll send a note when I do).

There are two important branches here (and I'll try to keep clutter down
by pruning dead branches):

 1) drm-intel-next

    This contains work destined for the 'next' release, it may include
    new functionality and performance enhancements. It may also cause
    regressions on some hardware. The tip of this tree will be sent
    to Dave Airlie for inclusion in the kernel during the next
    merge window. I've already sent all of what is on this branch
    to him for 3.0

    This tree should be tested during the development process to try and
    catch bugs and regressions before they are merged. The most critical
    time for testing this is just *before* the release of the current RC
    kernel version as that is when it should have most of the code
    planned for the *next* release.

 2) drm-intel-fixes

    This contains bug fixes after the merge window has closed. I will
    fast-forwarded to each RC when possible so that we test the fully
    integrated kernel for regressions.

    This tree should be tested during the stabilization process after RC1
    comes out as patches are applied.

If we need another tree or two to test integrated patch sequences for
major rework or new features, we can create other ones, but I hope to
keep it to just these two for ongoing work.

So, here's a typical kernel release cycle with notes on where we should
be focusing our efforts:

2.6.39
	The merge window is open and patches are flowing from
	drm-intel-next into Dave Airlie's drm-next branch.

	Testing should focus on drm-intel-next to ensure that we
	let as few bugs as possible leak into the main tree. The
	drm-intel-fixes branch should be essentially idle at this time,
	although if there are serious bugs in 2.6.39, fixes for those
	should be tested on drm-intel-fixes and then sent along to
	stable@ for integration in 2.6.39.1. I don't anticipate keeping
	a drm-intel-fixes branch open for each stable release.

3.0-RC1
        The merge window is closed. New features and major
	non-regression bug fixes will continue to land on
	drm-intel-next. Minor bug fixes and any regression fixes will
	land on drm-intel-fixes. The drm-intel-fixes tree will be sent
	directly to Linus for integration into the next RC or final
	release.

	Regressions on drm-intel-fixes will be dealt with swiftly -- if
	new feature or performance work that came from drm-intel-next
	cause regressions on any hardware, they must either be fixed or
	the new work will be reverted from the kernel. A regression
	which malingers through more than one RC is likely to be
	subjected to this harsh treatment.

	During early RC versions, we should focus our efforts on the
	drm-intel-fixes tree to track reported bugs, especially
	regressions, to make sure they are fixed as quickly as possible.

	However, we cannot afford to ignore the drm-intel-next
	branch. If major new code lands on that branch during this time,
	we need to schedule testing of that as soon as possible;
	otherwise, it will not be ready for the next kernel version.

...
3.0-RCx

	As we get close to the next release, there will be an
	accumulation of new code in the drm-intel-next branch and we
	must ensure that it is ready before the merge window
	opens. Plus, as the release gets closer, we must also ensure
	that any patches we do make on drm-intel-fixes cause no further
	problems. At this point, drm-intel-fixes and drm-intel-next will
	be significantly different.

	During later RC versions, we must split our attention between
	drm-intel-fixes to track issues in the next kernel version and
	drm-intel-next to ensure that code merged for the subsequent
	kernel are ready. By reducing the volume of patches to
	drm-intel-fixes, I hope to make this tractable.

3.0
	And the merge window opens, drm-intel-next becomes our primary
	focus as that is merged to drm-next and then to master.

I've been working with Dave Airlie to figure out when I can move the
base of the intel driver branches forward along master. Here's what I've
got so far:

drm-intel-fixes

	After the merge window closes and no further patches from
	drm-intel-next are anticipated, this branch will get pulled
	forward to -RC1. There will be nothing on this branch which is
	not in -RC1, so it will be a simple fast-forward (or something
        is messed up and needs fixing).

	Subsequently, when a PULL request is made and has been merged to
	master, drm-intel-fixes will get fast-forwarded to that merge
	point. If no further patches are pending between the merge point
	and the subsequent -RC release, drm-intel-fixes will get fast
	forwarded to that -RC.

	This includes pulling drm-intel-fixes forward to the final
	release in case we end up needing to prepare emergency patches
	for the .1 minor release.=20=20=20=20=20=20=20

	The part I'm less sure about is how to deal with patches that
	affect both drm/i915 and drm itself. In that case, we may have
	patches on both drm-intel-fixes and drm-fixes which work
	together to resolve an issue. I think the right thing will be to
	have drm-intel-fixes get merged into drm and from there be
	merged into master. That's what I've done with a set of fixes
        posted after 3.0-RC1.

	I'm interested in hearing comments about whether this will cause
	too many additional issues with merges from other parts of the
	kernel, or whether we'll end up far behind other trees somehow.

drm-intel-next

	While the merge window is closed, this tree will be accumulating
	patches in preparation for the subsequent merge window. However,
	to reduce the divergence from drm-intel-fixes, I'm proposing
	that drm-intel-fixes get merged to drm-intel-next whenever it is
	merged to master. I fully expect this to cause merge conflicts,
	but resolving those within our own tree before they are sent
	upstream should reduce the conflicts at that level. As
	drm-intel-fixes is periodically fast-forwarded to points along
	master, those merges will get pulled across to drm-intel-next.

	At the opening of the merge window, drm-intel-next should
	contain all of drm-intel-fixes from the release, and most of the
	rest of the release as well.

	During the merge window, patches that have been reviewed and
	tested on drm-intel-next will be included in a PULL request to
	Dave Airlie for merging into the drm tree.

	For patches which involve code in the core drm, we'll have those
	changes included in the drm-intel-next tree and they will get
	merged to drm-next from there.

Other feature branches

	I do not plan to maintain any additional branches for specific
	feature work in the drm/i915 tree. Those should be done in
	personal repositories, where they can be rebased as necessary
	before being merged to the drm/i915 tree.

Of course, there will probably exceptions to this plan. Those should be
clearly marked and suitable comments placed in commit messages.

Patches and commit messages

As I will be reviewing a significant number of patches heading to the
kernel, I will be requiring substantive, complete and correct commit
messages from developers. If the commit message does not include a
detailed description of the problem and the fix, expect to get a request
for more information. Please add any clarification to the commit message
the next time the patch is submitted.

For inclusion in drm-intel-fixes, any patch should have an associated
bug, and the commit message should include a link to the related
bugzilla entry. Fixes for regressions should be marked clearly as
such. During the later RC sequences, patches must be short and address
the bug directly, without any fancy bits.

All patches and pull requests should be sent to the intel-gfx, dri-devel
and linux-kernel mailing lists. Long sequences of patches are best
done with a pull request instead; as review comments come in, the branch
should be rebased so that it contains all of the updates, including
Tested-by, Acked-by and Reviewed-by lines.

Pull requests should be based from the related tree, and branch from a
point close to the current tip. Patches and pulls which don't merge
cleanly should be fixed by the author and re-submitted.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iD8DBQFN6xyjQp8BWwlsTdMRAjCfAKCjeTP4YepsbJvFq0qb4tFmHqlPHACfXjdA
hmfPWJESvxnelIwAkf/LvEs=
=VLQT
-----END PGP SIGNATURE-----
--=-=-=--
