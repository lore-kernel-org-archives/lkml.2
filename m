Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935368Ab1JGRla (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 13:41:30 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:48704 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934828Ab1JGRl0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 13:41:26 -0400
MIME-Version: 1.0
In-Reply-To: <1317721043.11231.2.camel@jmachine>
References: <1317721043.11231.2.camel@jmachine>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Fri, 7 Oct 2011 10:41:06 -0700
Message-ID: <CAB=NE6X81KPvx-yt33MghmoftUznoP-jYO8sBxoeW_0fzQ1pdA@mail.gmail.com>
Subject: Re: Using spdiff for backporting
To: Jesper Andersen <jespera@gmail.com>
Cc: julia@diku.dk, linux-wireless <linux-wireless@vger.kernel.org>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 4, 2011 at 2:37 AM, Jesper Andersen <jespera@gmail.com> wrote:
> Hi
>
> Somehow, I think the email below was never sent? Could either of you confirm my suspicion?

I just checked and I did get the original e-mail. Apologies for the
late reply. Below my reply.

> ====== Original email ======
>
> Here are a two results that I have found using spdiff on some of the
> patches from compat-wireless.
>
> 01-netdev:
> @@
> struct net_device *  X5;
> const struct net_device_ops X6;
> @@
> - X5->netdev_ops=&X6;
> + netdev_attach_ops(X5,&X6);
>
> 27-hermes-read-pda:
> @@
> struct hermes *  X0;
> @@
> - X0->ops->read_pda
> + X0->ops->read_pda_h
>
> Basically, I have done the following
>
> - clone the linux-next tree
> - apply a patch from compat-wireless/patches
> - git commit
> - extract pairs of original and modified files affected by the commit
>  (I call this set of pairs a "change set")
> - apply spdiff to the extracted pairs
> - adjust parameters to spdiff until something reasonable comes out
>
> For spdiff to work in its current form we need a change set with at
> least two similar modifications. For the netdev-ops case we actually
> have many changes matching "X5->netdev_ops=&X6" and seemingly those
> locations are all rewritten into: "netdev_attach_ops(X5,&X6)".
>
> For many of the patches in compat-wireless/patches, however such a
> scenario is not present. For example 03-rfkill consists of just one
> change of the string "rfkill" to "rfkill_backport". In this case spdiff
> cannot really infer anything useful.

Ah I see.

> The question is: given that spdiff in its current form really needs at
> least two example changes, could you perhaps point me at which of the
> patches in compat-wireless/patches should contain such things?

Sure thing. I'll review that and get back to you.

> Also, in the slides from the plumbers-conf. I think I saw it mentioned
> that there's also an alsa-compat git-tree somewhere. Maybe that is a
> more compelling usecase? I was unable to find it though so I'd
> appreciate a link.

It was on kernel.org, but if it got rm -rf'd then its gone as I do not
have a local copy. The compat-alsa stuff though was determined to be
superflous with the ALSA's team's own backport work which is currently
independent. My hope though is to unify these through the compat.git /
compat-kernel (currently just called compat-wireless) effort.

> A way that we maybe could get some more similar changes would be to
> focus on finding a patch for a specific version. E.g. for
> 09-threaded-irq there's a lot if #ifdefs for versions less than 2.6.31.
> In that case it seems for the lower version numbers, some code is added
> and for higher versions some other code has to be present. Instead, we
> could try to find a patch from the changes between >2.6.31 and <2.6.31
> perhaps?

Not sure I get this, could you elaborate a bit more? Are you saying to
cheat and double up the ifdef's for at least two older kernels or
newer kernels so that spatch gets two "change sets"?

> Or maybe you (Luis) have a better suggestion for how spdiff could be
> used. I am very open to modifications required specifically for doing
> backports work, I just need to get an idea for what would be useful to
> be able to infer. :-)

I'm perfectly happy with living with spdiff only helping with large
"change sets", and dealing with the rest of the patches manually.
Likely spdiff can help when we decide we want to add backport support
for a new subsystem, so we'd just apply the spatch's generated to the
new directories we want to consider, and then just require manual work
for what is left.

  Luis
