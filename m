Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933598Ab2EYPvB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 11:51:01 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:63443 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932577Ab2EYPu7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 11:50:59 -0400
MIME-Version: 1.0
In-Reply-To: <CAEFj985HxSrOwOoevDjG1jxPxobLda-X_LZUtj6LgwXZwozBog@mail.gmail.com>
References: <1337934071-29342-1-git-send-email-qasimj@gmail.com>
	<CAEFj985HxSrOwOoevDjG1jxPxobLda-X_LZUtj6LgwXZwozBog@mail.gmail.com>
Date: Fri, 25 May 2012 10:50:56 -0500
Message-ID: <CAJivULpmLp9JK+PQZ9RkrvvYHNk=uA33=A-ffftroigivy1_NQ@mail.gmail.com>
Subject: Re: [RFC] mac80211: Use correct originator sequence number in a Path Reply
From: Qasim Javed <qasimj@gmail.com>
To: devel@lists.open80211s.org
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, ravip@utdallas.edu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please see my comments below.

On Fri, May 25, 2012 at 10:30 AM, Yeoh Chun-Yeow <yeohchunyeow@gmail.com> wrote:
> Hi, Qasim Javed
>
> I think that you are referring to the target HWMP sequence number in
> PREP element.

No. I am referring to the originator sequence number in PREP because
when the PREP reaches the originator of the PREQ, the originator
sequence number in the PREP and the value of the metric is used to
determine which PREP will be accepted. If the originator sequence
numbers in the PREPs are different, then the PREP with the higher
sequence number will be accepted irrespective of the value of the
metric. Only if the originator sequence numbers in the PREP are equal
will the metric values in the PREPs be examined.

>
> Based on the 802.11s standard, it has specified that
> dot11MeshHWMPnetDiameterTraversalTime is only applied to original HWMP
> sequence number for PREQ as mentioned in the "Contents of a PREQ
> element" in section 11C.
>
> For PREP element, it should be based on the description in section 11C.9.8.3:
> "If it is a target mesh STA, it shall update its own HWMP sequence
> number to maximum (current HWMP sequence number, target HWMP sequence
> number in the PREQ) + 1 immediately before it generates a PREP in
> response to a PREQ. The target HWMP sequence number of the PREQ is
> relevant when a link was broken along the path and the stored sequence
> number was increased at an intermediate mesh STA."
>
> So the target HWMP sequence number should be modified as follow:
>
> diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
> index 70ac7d1..5988e82 100644
> --- a/net/mac80211/mesh_hwmp.c
> +++ b/net/mac80211/mesh_hwmp.c
> @@ -538,12 +538,10 @@ static void hwmp_preq_frame_process(struct
> ieee80211_sub_if_data *sdata,
>                forward = false;
>                reply = true;
>                metric = 0;
> -               if (time_after(jiffies, ifmsh->last_sn_update +
> -                                       net_traversal_jiffies(sdata)) ||
> -                   time_before(jiffies, ifmsh->last_sn_update)) {
> -                       target_sn = ++ifmsh->sn;
> -                       ifmsh->last_sn_update = jiffies;
> -               }
> +               if (SN_LT(ifmsh->sn, target_sn))
> +                       ifmsh->sn = target_sn;
> +               target_sn = ++ifmsh->sn;
> +               ifmsh->last_sn_update = jiffies;
>
> Comments.

I agree with the description in the standard but you seem to be
misinterpreting it. Please note that the function being considered
here is hwmp_preq_frame_process, which evidently processes a PREQ.
However, because a PREP is generated in response to a PREQ, this
function also checks whether a PREP needs to be generated and then
calls mesh_path_sel_frame_tx with frame type being MPATH_PREP. This
function is also passed the originator and target sequence numbers.

What I am saying is that, in the scenario described in my original
email, the wrong originator sequence number is being used for the
PREP.

Please notice that in hwmp_preq_frame_process, target_sn ends up being
used as orig_sn for the PREP. This is probably what is causing the
confusion in your case.

Your patch is definitely not what I was pointing out, in fact it
diverts from the standard functionality since it removes the check for
HWMPNetDiameterTraversalTime.

>
> Regards,
> Chun-Yeow
> _______________________________________________
> Devel mailing list
> Devel@lists.open80211s.org
> http://lists.open80211s.org/cgi-bin/mailman/listinfo/devel
