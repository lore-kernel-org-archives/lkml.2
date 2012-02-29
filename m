Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757802Ab2B2M76 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 07:59:58 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:46179 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756569Ab2B2M74 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 07:59:56 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of julian.calaby@gmail.com designates 10.50.219.170 as permitted sender) smtp.mail=julian.calaby@gmail.com; dkim=pass header.i=julian.calaby@gmail.com
MIME-Version: 1.0
In-Reply-To: <CAFxU49m76xaLGv9CFhKcZBhE-8QgT1KSuhnZRcVwzP2ogrGpbQ@mail.gmail.com>
References: <CAFxU49m76xaLGv9CFhKcZBhE-8QgT1KSuhnZRcVwzP2ogrGpbQ@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 29 Feb 2012 23:59:35 +1100
Message-ID: <CAGRGNgWngBAx4TRqW3sJ9EUEGW=YFgRD3vcqHMatWsyB=oDTOg@mail.gmail.com>
Subject: Re: [PATCH] mac80211: improve PID rate control mechanism by avoiding
 rate oscillation problem
To: YIN Wei <yinwei168@gmail.com>
Cc: johannes <johannes@sipsolutions.net>, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, mattias.nissler@gmx.de,
        stefano.brivio@polimi.it
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Yin,

Couple of notes on your patch and code formatting. I'll leave the
technical discussion to others.

First things first, your mailer has mangled line endings and turned
tabs into spaces in the patch, which means it won't apply without
being unmangled. For patches of a couple of lines from first time
submitters,  John will usually handle this, but your patch is a bit
too big to just deal with.

There's a file in the source tree: Documentation/email-clients.txt
which describes how to set up email clients to preserve the formatting
of patches.

On Wed, Feb 29, 2012 at 23:14, YIN Wei <yinwei168@gmail.com> wrote:
> From: Wei YIN (Wei.Yin@nicta.com.au)

Angle brackets around the email address (like Wei YIN <Wei.Yin@nicta.com.au>)

> Improve PID rate control mechanism by solving the rate oscillation
> problem. Current PID mechanism is based on a PID  controller which
> tries to minimise the difference between the frame loss ratio (FLR)
> and the target FLR. Therefore it is straight forward that it increases
> to a higher rate when the FLR is less than the target without
> considering whether the higher rate can be supported. If the higher
> rate cannot be supported, significant FLR will occur, which causes the
> mechanism to decrease the rate sharply. The proposed approach only
> updates the rate when the proposed rate by the PID controller can
> achieve better throughput than the old rate. This patch applies to
> kernel 3.3.0.

Add a blank line here, and your note about which kernel this applies
to should go below.

> Signed-off-by: Wei YIN (Wei.Yin@nicta.com.au)

Angle brackets again.

> ---

Notes about which kernel it applies to should go here - you should add
general notes about the patch itself here, and notes about the change
you're making within the patch above.

> diff -uprN wireless-testing_orig/net/mac80211/Kconfig
> wireless-testing/net/mac80211/Kconfig
> --- wireless-testing_orig/net/mac80211/Kconfig  2012-02-17
> 13:59:53.495254495 +1000
> +++ wireless-testing/net/mac80211/Kconfig       2012-02-21 11:35:40.495706869 +1000
> @@ -21,6 +21,7 @@ config MAC80211_HAS_RC
>  config MAC80211_RC_PID
>        bool "PID controller based rate control algorithm" if EXPERT
>        select MAC80211_HAS_RC
> +       default y

As Felix said, this change shouldn't be in the patch - you don't make
reference to it in the description and it's changing the default
behaviour of the kernel config. I'm sure that the Minstrel RC
algorithm was chosen as default for a reason, and without a similar
discussion it won't be set back to PID.

>        ---help---
>          This option enables a TX rate control algorithm for
>          mac80211 that uses a PID controller to select the TX
> diff -uprN wireless-testing_orig/net/mac80211/rc80211_pid_algo.c
> wireless-testing/net/mac80211/rc80211_pid_algo.c
> --- wireless-testing_orig/net/mac80211/rc80211_pid_algo.c       2012-02-17
> 13:59:53.495254495 +1000
> +++ wireless-testing/net/mac80211/rc80211_pid_algo.c    2012-02-29
> 11:01:32.043698711 +1000
> @@ -4,6 +4,8 @@
>  * Copyright 2007, Mattias Nissler <mattias.nissler@gmx.de>
>  * Copyright 2007-2008, Stefano Brivio <stefano.brivio@polimi.it>
>  *

Drop the blank line above to keep the copyright notices together.

> + * Copyright 2012, Wei Yin, National ICT Australia <Wei.Yin@nicta.com.au>
> + *
>  * This program is free software; you can redistribute it and/or modify
>  * it under the terms of the GNU General Public License version 2 as
>  * published by the Free Software Foundation.
> @@ -69,6 +71,90 @@
>  * exhibited a worse failed frames behaviour and we'll choose the highest rate
>  * whose failed frames behaviour is not worse than the one of the original rate
>  * target. While at it, check that the new rate is valid. */
> +
> +/* Solve the rate oscilation problem in PID. The idea of PID is based on
> + * control systemâ€™s principle of a feedback loop. That is, defining a target
> + * frame loss ratio (FLR) â€” e.g., the target FLR in PID is fixed at
> 14% â€” let

Your mailer seems to have mangled the apostrophes. You might also want
to re-consider blindly copying and pasting from Word / Libreoffice.

> + * the rate control mechanism to adapt its rate to meet that target by
> + * minimising the difference between the current FLR  and the target FLR. It
> + * is very straight forward; such that PID drops the sending rate when FLR is
> + * greater than 14%, while increases the sending rate when FLR is less than the
> + * target FLR. During the adaptation process PID will increase the rate
> + * whenever the current FLR is below the target threshold, regardless the
> + * current channel conditions which may not be sufficient to support the
> + * higher rate. The consequence of this is the FLR of the higher rate is
> + * higher than the target threshold and this causes PID to drop the rate
> + * again. Hence, this results in oscillation in rate selection as shown in the
> + * paper "Performance of mac80211 rate control mechanisms".

If you're referencing a paper, it might be an idea to include a URL or
at least some basic bibliographic information so an interested reader
can find it quickly.

> + *
> + * In the proposed approach, when a new rate is proposed by PID controller,
> + * if it is different from the current rate, PIDE will first use a monitor
> + * window (a rate adaptation period long) to check its performance before
> + * adopting it. To achieve this, PIDE sends n frames (e.g., current
> + * implementation uses three frames) using the proposed rate in the next rate
> + * adaptation period. Other frames within next adaptation period will continue
> + * to use the old rate. The proposed rate will be adopted if it is better than
> + * the old rate.
> + *
> + * The debug fs is also changed to monitor PID performance. see /sys/kernel/
> + * debug/ieee80211/phy0/netdev\:wlan0/stations/MAC_ADDR/rc_pid_events

I'm not sure there should be a '\' before the ':' in "netdev\:wlan0"
in this path.

> + *

You also should probably get rid of this blank line.

> + */
> +
> +static int pide_frame_duration(int band, size_t len,
> +                            int rate, int erp, int short_preamble)
> +{
> +       int dur = 0;
> +
> +       /* calculate duration (in microseconds, rounded up to next higher
> +        * integer if it includes a fractional microsecond) to send frame of
> +        * len bytes (does not include FCS) at the given rate. Duration will
> +        * also include SIFS.
> +        *
> +        * rate is in 100 kbps, so divident is multiplied by 10 in the
> +        * DIV_ROUND_UP() operations.
> +        */
> +
> +       if (band == IEEE80211_BAND_5GHZ || erp) {
> +               /*
> +                * OFDM:
> +                *
> +                * N_DBPS = DATARATE x 4
> +                * N_SYM = Ceiling((16+8xLENGTH+6) / N_DBPS)
> +                *      (16 = SIGNAL time, 6 = tail bits)
> +                * TXTIME = T_PREAMBLE + T_SIGNAL + T_SYM x N_SYM + Signal Ext
> +                *
> +                * T_SYM = 4 usec
> +                * 802.11a - 17.5.2: aSIFSTime = 16 usec
> +                * 802.11g - 19.8.4: aSIFSTime = 10 usec +
> +                *      signal ext = 6 usec
> +                */
> +
> +               dur += 16; /* 17.3.2.3: T_PREAMBLE = 16 usec */
> +               dur += 4; /* 17.3.2.3: T_SIGNAL = 4 usec */
> +               dur += 4 * DIV_ROUND_UP((16 + 8 * (len + 4) + 6) * 10,
> +                                       4 * rate); /* T_SYM x N_SYM */

I'm sure that what you're saying here with the comments could be made
more concise. Maybe reference the sections of the spec in the main
block, and remove the duplicate values. Remember that code is also
documentation. A well written block of code is usually
self-documenting, and people who work on this stuff don't (usually)
need it all spelled out for them.

> +       } else {
> +               /*
> +                * 802.11b or 802.11g with 802.11b compatibility:
> +                * 18.3.4: TXTIME = PreambleLength + PLCPHeaderTime +
> +                * Ceiling(((LENGTH+PBCC)x8)/DATARATE). PBCC=0.
> +                *
> +                * 802.11 (DS): 15.3.3, 802.11b: 18.3.4
> +                * aSIFSTime = 10 usec
> +                * aPreambleLength = 144 usec or 72 usec with short preamble
> +                * aPLCPHeaderLength = 48 usec or 24 usec with short preamble
> +                */
> +
> +               dur += short_preamble ? (72 + 24) : (144 + 48);
> +
> +               dur += DIV_ROUND_UP(8 * (len + 4) * 10, rate);

This is somewhat better.

> +       }
> +
> +       return dur;
> +}
> +
>  static void rate_control_pid_adjust_rate(struct
> ieee80211_supported_band *sband,
>                                         struct ieee80211_sta *sta,
>                                         struct rc_pid_sta_info *spinfo, int adj,
> @@ -109,7 +195,8 @@ static void rate_control_pid_adjust_rate
>        /* Fit the rate found to the nearest supported rate. */
>        do {
>                if (rate_supported(sta, band, rinfo[tmp].index)) {
> -                       spinfo->txrate_idx = rinfo[tmp].index;
> +                       /* PIDE: record proposed rate as a temporary rate. */

You don't need to comment everything you do.

> +                       spinfo->tmp_rate_idx = rinfo[tmp].index;
>                        break;
>                }
>                if (adj < 0)
> @@ -301,8 +554,15 @@ rate_control_pid_rate_init(void *priv, s
>        int i, j, tmp;
>        bool s;
>
> +       /* PIDE: n is the number of transmission rates available */
> +       int n = 0;
> +       struct ieee80211_rate *ctl_rate;
> +       int band_info = 0;
> +
> +       int erp = 0, sifs = 0;
> +
>        /* TODO: This routine should consider using RSSI from previous packets
> -        * as we need to have IEEE 802.1X auth succeed immediately after assoc..
> +        * as we need to have IEEE 802.1X auth succeed immediately after assoc.

This is exceedingly minor, but formatting and spelling changes should
probably be in a separate patch.

>         * Until that method is implemented, we will use the lowest supported
>         * rate as a workaround. */
>
> @@ -318,22 +578,61 @@ rate_control_pid_rate_init(void *priv, s
>                        rinfo[i].diff = i * pinfo->norm_offset;
>        }
>        for (i = 1; i < sband->n_bitrates; i++) {
> -               s = false;
> +               s = 0;

Why are you using integers with a boolean variable?

>                for (j = 0; j < sband->n_bitrates - i; j++)
>                        if (unlikely(sband->bitrates[rinfo[j].index].bitrate >
> -                                    sband->bitrates[rinfo[j + 1].index].bitrate)) {
> +                               sband->bitrates[rinfo[j + 1].index].bitrate)) {
>                                tmp = rinfo[j].index;
>                                rinfo[j].index = rinfo[j + 1].index;
>                                rinfo[j + 1].index = tmp;
>                                rinfo[rinfo[j].index].rev_index = j;
>                                rinfo[rinfo[j + 1].index].rev_index = j + 1;
> -                               s = true;
> +                               s = 1;
>                        }
>                if (!s)
>                        break;
> diff -uprN wireless-testing_orig/net/mac80211/rc80211_pid_debugfs.c
> wireless-testing/net/mac80211/rc80211_pid_debugfs.c
> --- wireless-testing_orig/net/mac80211/rc80211_pid_debugfs.c    2012-02-17
> 13:59:53.487182968 +1000
> +++ wireless-testing/net/mac80211/rc80211_pid_debugfs.c 2012-02-29
> 09:31:06.347703730 +1000
> @@ -13,13 +14,74 @@
>  #include <linux/types.h>
>  #include <linux/skbuff.h>
>  #include <linux/slab.h>
> -#include <linux/export.h>
> -

This change should probably go in a separate patch.

>  #include <net/mac80211.h>
>  #include "rate.h"
>
>  #include "rc80211_pid.h"
>
> +#include <linux/debugfs.h>
> +#include <linux/ieee80211.h>
> +#include <linux/slab.h>
> +#include <linux/export.h>
> +
> +

Extra line

> +int
> +pid_stats_open(struct inode *inode, struct file *file)
> +{
> +       struct rc_pid_sta_info *sinfo = inode->i_private;
> +       struct rc_pid_debugfs_info *ms;
> +       struct rc_pid_rateinfo *rinfo;
> +       char *p;
> +       int i;

You should add an extra line here.

> +       rinfo = sinfo->rinfo;

This could go into the variable definition above.

> +       ms = kmalloc(sizeof(*ms) + 4096, GFP_KERNEL);
> +       if (!ms)
> +               return -ENOMEM;
> +
> +       file->private_data = ms;
> +       p = ms->buf;
> +       p += sprintf(p, "R for current rate;   T for temporary rate\n");
> +       p += sprintf(p, "rate    throughput      attempt          fail");
> +       p += sprintf(p, "        success         this_FLR \n");

You've added an extra space at the end of the line in the sprintf call.

Also, C automatically combines strings that follow each other, so this
could be written as:

+       p += sprintf(p, "R for current rate;   T for temporary rate\n"
+                       "rate    throughput      attempt          fail"
+                       "        success         this_FLR \n");

> +       for (i = 0; i < sinfo->n_rates; i++) {
> +               struct rc_pid_rateinfo *pr = &rinfo[i];
> +               *(p++) = (i == sinfo->txrate_idx) ? 'R' : ' ';
> +               *(p++) = (i == sinfo->tmp_rate_idx) ? 'T' : ' ';

You could put this into the sprintf calls below.

> +               p += sprintf(p, "%3u%s", pr->bitrate / 2,
> +                               (pr->bitrate & 1 ? ".5" : "  "));
> +               p += sprintf(p,
> +                        "%6u.%2u     %10lu     %10lu     %10lu        %2u%%\n",
> +                        (pr->throughput * 1530 *8 / 1024 / 1024) /100,
> +                        (pr->throughput * 1530 *8 / 1024 / 1024) % 100,
> +                        pr->attempt, pr->fail, pr->success,
> +                        pr->this_fail == 0 ? 0:
> +                        (pr->this_fail *100 /
> +                        pr->this_attempt) % 100);

I'm guessing that this probably won't overflow, but it makes me
nervous that you're not checking for the end of the buffer when
building this string.

> +       }
> +
> +       ms->len = p - ms->buf;
> +
> +       return 0;
> +}
> +
> +ssize_t
> +pid_stats_read(struct file *file, char __user *buf, size_t len, loff_t *ppos)
> +{
> +       struct rc_pid_debugfs_info *ms;
> +
> +       ms = file->private_data;
> +       return simple_read_from_buffer(buf, len, ppos, ms->buf, ms->len);
> +}
> +
> +int
> +pid_stats_release(struct inode *inode, struct file *file)
> +{
> +       kfree(file->private_data);
> +       return 0;
> +}
> +
> +
> +

Extra lines

>  static void rate_control_pid_event(struct rc_pid_event_buffer *buf,
>                                   enum rc_pid_event_type type,
>                                   union rc_pid_event_data *data)
> @@ -130,7 +192,8 @@ static unsigned int rate_control_pid_eve
>
>  #define RC_PID_PRINT_BUF_SIZE 64
>
> -static ssize_t rate_control_pid_events_read(struct file *file, char
> __user *buf,
> +static ssize_t rate_control_pid_events_read(struct file *file,
> +                                           char __user *buf,

Another change that should probably go into a separate patch.

>                                            size_t length, loff_t *offset)
>  {
>        struct rc_pid_events_file_info *file_info = file->private_data;
> @@ -163,7 +226,7 @@ static ssize_t rate_control_pid_events_r
>        file_info->next_entry = (file_info->next_entry + 1) %
>                                RC_PID_EVENT_RING_SIZE;
>
> -       /* Print information about the event. Note that userspace needs to
> +       /* Print information about the event. Note that userpace needs to

You've added a spelling mistake.

>         * provide large enough buffers. */
>        length = length < RC_PID_PRINT_BUF_SIZE ?
>                 length : RC_PID_PRINT_BUF_SIZE;
> @@ -226,3 +287,4 @@ void rate_control_pid_remove_sta_debugfs
>
>        debugfs_remove(spinfo->events_entry);
>  }
> +

Adding an extra line at the end of the file is unnecessary.

> diff -uprN wireless-testing_orig/net/mac80211/rc80211_pid.h
> wireless-testing/net/mac80211/rc80211_pid.h
> --- wireless-testing_orig/net/mac80211/rc80211_pid.h    2012-02-17
> 13:59:53.403182811 +1000
> +++ wireless-testing/net/mac80211/rc80211_pid.h 2012-02-29
> 10:45:28.043682855 +1000
> @@ -48,6 +52,14 @@
>  #define RC_PID_DO_ARITH_RIGHT_SHIFT(x, y) \
>        ((x) < 0 ? -((-(x)) >> (y)) : (x) >> (y))
>
> +#define MAXPROBES 3
> +
> +

Extra line

> +/* PIDE */
> +
> +#define Tdifs 34
> +#define Tslot 9

#define names should be in CAPITALS

> +
>  enum rc_pid_event_type {
>        RC_PID_EVENT_TYPE_TX_STATUS,
>        RC_PID_EVENT_TYPE_RATE_CHANGE,
> @@ -77,7 +89,7 @@ union rc_pid_event_data {
>  };
>
>  struct rc_pid_event {
> -       /* The time when the event occurred */
> +       /* The time when the event occured */

You've added another spelling mistake

>        unsigned long timestamp;
>
>        /* Event ID number */
> @@ -118,6 +130,14 @@ struct rc_pid_events_file_info {
>        unsigned int next_entry;
>  };
>
> +/* PIDE: debug fs */
> +struct rc_pid_debugfs_info {
> +       size_t len;
> +       char buf[];
> +};
> +
> +
> +

Extra lines

>  /**
>  * struct rc_pid_debugfs_entries - tunable parameters
>  *
> @@ -169,6 +189,15 @@ void rate_control_pid_add_sta_debugfs(vo
>
>  void rate_control_pid_remove_sta_debugfs(void *priv, void *priv_sta);
>
> +/* PIDE; debug file system */
> +
> +int pid_stats_open(struct inode *inode, struct file *file);
> +ssize_t pid_stats_read(struct file *file, char __user *buf, size_t len,
> +                      loff_t *ppos);
> +int pid_stats_release(struct inode *inode, struct file *file);
> +
> +
> +

Extra lines

>  struct rc_pid_sta_info {
>        unsigned long last_change;
>        unsigned long last_sample;
> @@ -219,6 +248,20 @@ struct rc_pid_sta_info {
>
>        /* Events debugfs file entry */
>        struct dentry *events_entry;
> +
> +       /* PIDE */
> +       int last_dlr;
> +       int fail_probes;
> +       int probes;
> +       int monitoring;
> +       int oldrate;
> +       int n_rates;
> +       int tmp_rate_idx;
> +       int probe_cnt;
> +
> +       struct rc_pid_rateinfo *rinfo;
> +
> +

Extra lines

>  #endif
>  };
>
> @@ -235,9 +278,21 @@ struct rc_pid_rateinfo {
>
>        /* Did we do any measurement on this rate? */
>        bool valid;
> -
> +

Don't make this change.

>        /* Comparison with the lowest rate. */
>        int diff;
> +
> +       /* PIDE */
> +       int bitrate;
> +       int perfect_tx_time;
> +       unsigned int throughput;
> +       unsigned int this_attempt;
> +       unsigned int this_success;
> +       unsigned int this_fail;
> +       unsigned long attempt;
> +       unsigned long success;
> +       unsigned long fail;
> +

Extra line

>  };
>
>  struct rc_pid_info {

Overall, I'm sure that this is a good patch, it just has a few minor
formatting issues.

I'm sure there will be other comments about the code itself, so don't
write a new patch just to address all these issues, but make these
changes when you submit the next version. Also, as I'm sure you know
already, when you send the next version, change the subject to read
"[PATCH v2] ...." so that people following the discussion will see
when you've mailed an updated patch.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
