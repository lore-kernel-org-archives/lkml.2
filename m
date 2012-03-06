Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030417Ab2CFLcF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 06:32:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60300 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965129Ab2CFLcB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 06:32:01 -0500
Message-ID: <4F55F598.7050406@redhat.com>
Date: Tue, 06 Mar 2012 08:31:36 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv5] EDAC core changes in order to properly report errors
 from all types of memory controllers
References: <1330698314-9863-1-git-send-email-bp@amd64.org> <1330698314-9863-5-git-send-email-bp@amd64.org> <4F50DECB.8030200@redhat.com> <20120305110441.GC1070@aftab> <4F54A6FF.50502@redhat.com> <20120305124411.GD1070@aftab> <4F54C133.6040709@redhat.com> <20120305141349.GF1070@aftab> <4F54D4AF.9060802@redhat.com> <4F553764.5070305@redhat.com> <20120305232319.GA7175@aftab>
In-Reply-To: <20120305232319.GA7175@aftab>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 05-03-2012 20:23, Borislav Petkov escreveu:
> On Mon, Mar 05, 2012 at 07:00:04PM -0300, Mauro Carvalho Chehab wrote:
>> With those changes, there's just one tracepont defined there, on this patchset:
>> 	http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-edac.git;a=commit;h=fdfa64045e43c942e1250708365d9240cd0da9c3
> 
> Ok, here's my take from simply skimming over the patchset for 5 mins:
> 
> * first of all, a lot of the patches are done sloppily and have no commit
> messages whatsoever. This is a no-no and the first thing you need to fix.

Yes, sure. Most of the patches after changeset dd3309c are fixes, noticed 
during the test phasis.

The above changeset is huge and complex, as it changes the internal API,
affecting all drivers.

I'm testing the patchset on i3000, i3200, i5000, i5100, i5400, i7300,
i7core_edac, SB, amd64, x38, ...

As I'm getting regressions, I'm adding fixes on the series.

It likely makes sense to fold them into it, or to better describe them.

> 
> * http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-edac.git;a=commitdiff;h=ad015450e549b29a74283733048254d3c647a33at is humongous, has no commit message and contains a lot of changes which probably deserve a patch of their own. Mauro, you're not doing this since yesterday, you should know better!

While the patch is complex, the description here is simple: basically the
FB-DIMM drivers were using the wrong offset for the dimm array. I'll better
describe it on v6.

> * http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-edac.git;a=commitdiff;h=ccca89bce4c0515aabd67440ba01ede97d2b4dcc removes crap introduced by earlier patches in the series, so also a no-no and needs to be fixed.

Yes, it should be fold with a previous patch (likely with d943730b4a86a594d5fb83849d66442e7f9c600a).

> * WTF does the commit message of http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-edac.git;a=commitdiff;h=c911a426ef72c817222e7c2ab302a81b69ccbd07 mean? Looks like it redacts a huge function you've introduced in an earlier patch... Hell, no!

It changes the behavior of a logic I've introduced. Before this patch, one
sysfs node is created for every element at the hierarchy (branch/channel/dimm),
even if there's nothing populated there. 

The new logic checks if is there any memory inserted on it, before creating
the nodes.

I opted to have it on a separate patchset.
> 
> ...
> 
> * And, last but not least, your patches touch amd64_edac* extensively,
> and, I need to properly review those changes before they get committed.

Yes, sure you need to review. 

You'll see there that most of the changes there are trivial:

- there's now just one function to report errors, so, all lines that call the
  error report routines got changed. This is a trivial change;

- there's no need, on amd64, to fill the data structures used by the EDAC code
  to convert from physical memory into csrow/channel, as the amd64 driver
  doesn't call the EDAC core routine that does such calculus
  (first_page/last_page stuff). So, there's some cleanup there;

- I've re-ordered some parsing blocks at amd64_edac, in order to benefit on
  the edac core improvements: as there's now just one error handling routine,
  if the parser fails, for example, to get the channel, all it needs to do is
  to fill the channel with "-1". The EDAC core will remove "channel" from the
  error location information. This removed the need for the separate "fbd"
  variants of the error functions.

The amd64 changes are:

$ git log --oneline v3.2.. drivers/edac/amd64_edac.c 
a582cfa Fix memory error count
ccca89b amd64_edac: remove a duplicated call to edac_mc_handle_error()
dd3309c edac: rework memory layer hierarchy description
d943730 edac-mc: Allow reporting errors on a non-csrow oriented way
7967d1d edac: DIMM location cleanup
50048a7 edac: move nr_pages to dimm struct
8e83f0a edac: Don't initialize csrow's first_page & friends when not needed
53144b2 edac: move dimm properties to struct memset_info

The last two patches should be fold on dd3309c, as they fixes the logic
there.

> So, my absolutely sincere suggestion to you is to split this huge
> patchset into smaller patchsets containing 5-10 patches, making it much
> easier to review, 

Breaking it into smaller patchsets is not trivial, as the analysis of the
individual changesets only makes sense in the light of the big change on
the edac core structures. One alternative would be to fold patches, but
this would mean to loose some details.

> go over <Documentation/SubmittingPatches> and refresh
> your knowledge on how a proper patch should look like and what it should
> contain, test your stuff properly on the machines it addresses and
> _only_ _then_ send them to the relevant parties for proper review - not
> earlier.

Linux workflow works better with commit soon/commit often.

As the internal representation changed, and the API calls as well, all
drivers are potentially affected.

I'm testing it on a broad range of machines we have available at Red Hat, 
even replacing some memories at the selected hardware in order to see how 
the driver behaves on different situations.

Even replacing the memories on the test systems I can, it is unlikely
that I'll be able to test all possible memory combinations. So, I expect 
that the others can give me some feedback about other systems I may not
have, or where I may not be able to discover some special case where a
regression might be introduced.

That's why I'm feeding the ML with the patches I'm working with.

Besides that, holding patches to be reviewed at the end of all tests will 
just increase the number of patches at the changeset.

So, it is better to work on get reviews and merging what's there for -next,
and then move ahead, applying other fixes as needed, instead of rebasing
everything for every discovered bug or regression.

Btw, there are several patches on this series fixing existing bugs on
the drivers, discovered on such tests. For example, see changeset
88617ec94595 (i5000_edac):

The previous (upstream) logic for handle_channel() was:

static void handle_channel(struct i5000_pvt *pvt, int csrow, int channel,
			struct i5000_dimm_info *dinfo)
{
	int mtr;
	int amb_present_reg;
	int addrBits;

	mtr = determine_mtr(pvt, csrow, channel);
	if (MTR_DIMMS_PRESENT(mtr)) {
		amb_present_reg = determine_amb_present_reg(pvt, channel);

		/* Determine if there is  a  DIMM present in this DIMM slot */
		if (amb_present_reg & (1 << (csrow >> 1))) {
			dinfo->dual_rank = MTR_DIMM_RANK(mtr);

			if (!((dinfo->dual_rank == 0) &&
				((csrow & 0x1) == 0x1))) {
				/* Start with the number of bits for a Bank
				 * on the DRAM */
				addrBits = MTR_DRAM_BANKS_ADDR_BITS(mtr);
				/* Add thenumber of ROW bits */
				addrBits += MTR_DIMM_ROWS_ADDR_BITS(mtr);
				/* add the number of COLUMN bits */
				addrBits += MTR_DIMM_COLS_ADDR_BITS(mtr);

				addrBits += 6;	/* add 64 bits per DIMM */
				addrBits -= 20;	/* divide by 2^^20 */
				addrBits -= 3;	/* 8 bits per bytes */

				dinfo->megabytes = 1 << addrBits;
			}
		}
	}
}

The above logic calculates and fills the DIMM memory size (dinfo->megabytes),
that it is latter used to calculate the dimm number of pages. The edac core
only shows the sysfs nodes for a csrow/channel if the number of pages for the
memory is not zero. 

As the size is only calculated if the memory is dual-rank, that means
that the i5000 edac driver doesn't work properly with single rank memories,
as size would be zero.

The above "emulation" logic seems to be trying to make a dual-rank FB-DIMM to
look like a csrow-based memory controller, e. g. creating two csrows per DIMM.

This is a good example of drivers workarounds introduced due to the lack of a
proper support for non-csrow-based memory controllers.

On a csrow-based MC, dual-rank memories would be mapped as two separate 
(csrow, channel) addresses. Each will have half of the DIMM size on each
address. The above "emulation" creates two (csrow, channel) addreses for every
FB-DIMM, filling just one, but only if the memory is dual-rank.

For a FB-DIMM controller, the number of ranks is just a detail associated with
a given DIMM slot, as the memory is selected by slot, and not by rank.

So, the logic is completely broken for single-rank memories and half-broken for 
double-rank ones.

This is an example of a patch that should not be fold.

After this patch, the memories on the i5000 machine I'm testing are properly
reported, being single-rank or dual-rank.

Regards,
Mauro
