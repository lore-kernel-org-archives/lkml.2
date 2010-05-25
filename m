Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab0EYLzt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 07:55:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50308 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754245Ab0EYLzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 07:55:46 -0400
Date: Tue, 25 May 2010 13:55:44 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jassi Brar <jassisinghbrar@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       devel@driverdev.osuosl.org
Subject: Re: [PATCH] staging: remove all code dependent on
 LINUX_VERSION_CODE
In-Reply-To: <AANLkTik-k5lECpQtbsQy8DLJJ3DOPrAz_e5XPPMzgr2o@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1005251355100.28092@pobox.suse.cz>
References: <alpine.LNX.2.00.1005251200410.28092@pobox.suse.cz> <AANLkTik-k5lECpQtbsQy8DLJJ3DOPrAz_e5XPPMzgr2o@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 May 2010, Jassi Brar wrote:

> > diff --git a/drivers/staging/cxt1e1/hwprobe.c b/drivers/staging/cxt1e1/hwprobe.c
> > index 4c86102..c52ff7c 100644
> > --- a/drivers/staging/cxt1e1/hwprobe.c
> > +++ b/drivers/staging/cxt1e1/hwprobe.c
> > @@ -305,15 +305,9 @@ c4hw_attach_all (void)
> >     error_flag = 0;
> >     prep_hdw_info ();
> >     /*** scan PCI bus for all possible boards */
> > -#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
> > -    while ((pdev = pci_get_device (PCI_VENDOR_ID_CONEXANT,
> > -                                   PCI_DEVICE_ID_CN8474,
> > -                                   pdev)))
> > -#else
> >     while ((pdev = pci_find_device (PCI_VENDOR_ID_CONEXANT,
> >                                     PCI_DEVICE_ID_CN8474,
> >                                     pdev)))
> > -#endif
> >     {
> >         if (c4_hdw_init (pdev, found))
> >             found++;
> 
> It should be the other way around.

Thanks a lot for catching this. Updated patch below.


From: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] staging: remove all code dependent on LINUX_VERSION_CODE

Remove all code which is dead for in-kernel driver due to being
ifdefed by LINUX_VERSION_CODE.

While at it, also remove surrounding code which is commented out,
or '#if 1' nops.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 drivers/staging/cxt1e1/functions.c                 |   12 --
 drivers/staging/cxt1e1/hwprobe.c                   |    6 -
 drivers/staging/cxt1e1/linux.c                     |  118 -----------
 drivers/staging/cxt1e1/musycc.c                    |  204 --------------------
 drivers/staging/cxt1e1/pmc93x6_eeprom.c            |    4 -
 drivers/staging/cxt1e1/pmcc4.h                     |    6 -
 drivers/staging/cxt1e1/pmcc4_drv.c                 |  158 ---------------
 drivers/staging/cxt1e1/sbecom_inline_linux.h       |   11 -
 drivers/staging/rtl8192e/ieee80211/dot11d.c        |   18 --
 drivers/staging/rtl8192e/ieee80211/ieee80211.h     |  107 ----------
 .../staging/rtl8192e/ieee80211/ieee80211_crypt.c   |   20 --
 .../staging/rtl8192e/ieee80211/ieee80211_crypt.h   |    8 -
 .../rtl8192e/ieee80211/ieee80211_crypt_ccmp.c      |   48 -----
 .../rtl8192e/ieee80211/ieee80211_crypt_tkip.c      |  198 +-------------------
 .../rtl8192e/ieee80211/ieee80211_crypt_wep.c       |   96 +---------
 .../staging/rtl8192e/ieee80211/ieee80211_module.c  |   68 -------
 drivers/staging/rtl8192e/ieee80211/ieee80211_rx.c  |   12 +-
 .../staging/rtl8192e/ieee80211/ieee80211_softmac.c |  173 +-----------------
 .../rtl8192e/ieee80211/ieee80211_softmac_wx.c      |   70 +-------
 drivers/staging/rtl8192e/ieee80211/ieee80211_tx.c  |    9 -
 drivers/staging/rtl8192e/ieee80211/ieee80211_wx.c  |  130 +------------
 .../staging/rtl8192e/ieee80211/rtl819x_HTProc.c    |   17 +--
 drivers/staging/rtl8192su/r8192SU_led.c            |    9 -
 23 files changed, 7 insertions(+), 1495 deletions(-)

diff --git a/drivers/staging/cxt1e1/functions.c b/drivers/staging/cxt1e1/functions.c
index 86b4980..23ea101 100644
--- a/drivers/staging/cxt1e1/functions.c
+++ b/drivers/staging/cxt1e1/functions.c
@@ -122,19 +122,7 @@ watchdog_func (unsigned long arg)
             pr_warning("%s: drvr not available (%x)\n", __func__, drvr_state);
         return;
     }
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-    /* Initialize the tq entry only the first time */
-    if (wd->init_tq)
-    {
-        wd->init_tq = 0;
-        wd->tq.routine = wd->func;
-        wd->tq.sync = 0;
-        wd->tq.data = wd->softc;
-    }
-    schedule_task (&wd->tq);
-#else
     schedule_work (&wd->work);
-#endif
     mod_timer (&wd->h, jiffies + wd->ticks);
 }
 
diff --git a/drivers/staging/cxt1e1/hwprobe.c b/drivers/staging/cxt1e1/hwprobe.c
index 4c86102..89200e7 100644
--- a/drivers/staging/cxt1e1/hwprobe.c
+++ b/drivers/staging/cxt1e1/hwprobe.c
@@ -305,15 +305,9 @@ c4hw_attach_all (void)
     error_flag = 0;
     prep_hdw_info ();
     /*** scan PCI bus for all possible boards */
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,0)
     while ((pdev = pci_get_device (PCI_VENDOR_ID_CONEXANT,
-                                   PCI_DEVICE_ID_CN8474,
-                                   pdev)))
-#else
-    while ((pdev = pci_find_device (PCI_VENDOR_ID_CONEXANT,
                                     PCI_DEVICE_ID_CN8474,
                                     pdev)))
-#endif
     {
         if (c4_hdw_init (pdev, found))
             found++;
diff --git a/drivers/staging/cxt1e1/linux.c b/drivers/staging/cxt1e1/linux.c
index 134e756..ace28c7 100644
--- a/drivers/staging/cxt1e1/linux.c
+++ b/drivers/staging/cxt1e1/linux.c
@@ -142,10 +142,6 @@ getuserbychan (int channum)
 }
 
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-#define DEV_TO_PRIV(dev) ( * (struct c4_priv **) ((hdlc_device*)(dev)+1))
-#else
-
 char       *
 get_hdlc_name (hdlc_device * hdlc)
 {
@@ -154,7 +150,6 @@ get_hdlc_name (hdlc_device * hdlc)
 
     return dev->name;
 }
-#endif
 
 
 static      status_t
@@ -167,7 +162,6 @@ mkret (int bsd)
 }
 
 /***************************************************************************/
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,41)
 #include <linux/workqueue.h>
 
 /***
@@ -259,7 +253,6 @@ c4_wq_port_cleanup (mpi_t * pi)
         pi->wq_port = 0;
     }
 }
-#endif
 
 /***************************************************************************/
 
@@ -291,48 +284,6 @@ void_open (struct net_device * ndev)
 }
 
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-#if !defined(GENERIC_HDLC_VERSION) || (GENERIC_HDLC_VERSION < 4)
-
-/** Linux 2.4.18-19 **/
-STATIC int
-chan_open (hdlc_device * hdlc)
-{
-    status_t    ret;
-
-    if ((ret = c4_chan_up (DEV_TO_PRIV (hdlc)->ci, DEV_TO_PRIV (hdlc)->channum)))
-        return -ret;
-    MOD_INC_USE_COUNT;
-    netif_start_queue (hdlc_to_dev (hdlc));
-    return 0;                       /* no error = success */
-}
-
-#else
-
-/** Linux 2.4.20 and higher **/
-STATIC int
-chan_open (struct net_device * ndev)
-{
-    hdlc_device *hdlc = dev_to_hdlc (ndev);
-    status_t    ret;
-
-    hdlc->proto = IF_PROTO_HDLC;
-    if ((ret = hdlc_open (hdlc)))
-    {
-        pr_info("hdlc_open failure, err %d.\n", ret);
-        return ret;
-    }
-    if ((ret = c4_chan_up (DEV_TO_PRIV (hdlc)->ci, DEV_TO_PRIV (hdlc)->channum)))
-        return -ret;
-    MOD_INC_USE_COUNT;
-    netif_start_queue (hdlc_to_dev (hdlc));
-    return 0;                       /* no error = success */
-}
-#endif
-
-#else
-
-/** Linux 2.6 **/
 STATIC int
 chan_open (struct net_device * ndev)
 {
@@ -351,39 +302,8 @@ chan_open (struct net_device * ndev)
     netif_start_queue (ndev);
     return 0;                       /* no error = success */
 }
-#endif
 
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-#if !defined(GENERIC_HDLC_VERSION) || (GENERIC_HDLC_VERSION < 4)
-
-/** Linux 2.4.18-19 **/
-STATIC void
-chan_close (hdlc_device * hdlc)
-{
-    netif_stop_queue (hdlc_to_dev (hdlc));
-    musycc_chan_down ((ci_t *) 0, DEV_TO_PRIV (hdlc)->channum);
-    MOD_DEC_USE_COUNT;
-}
-#else
-
-/** Linux 2.4.20 and higher **/
-STATIC int
-chan_close (struct net_device * ndev)
-{
-    hdlc_device *hdlc = dev_to_hdlc (ndev);
-
-    netif_stop_queue (hdlc_to_dev (hdlc));
-    musycc_chan_down ((ci_t *) 0, DEV_TO_PRIV (hdlc)->channum);
-    hdlc_close (hdlc);
-    MOD_DEC_USE_COUNT;
-    return 0;
-}
-#endif
-
-#else
-
-/** Linux 2.6 **/
 STATIC int
 chan_close (struct net_device * ndev)
 {
@@ -396,7 +316,6 @@ chan_close (struct net_device * ndev)
     module_put (THIS_MODULE);
     return 0;
 }
-#endif
 
 
 #if !defined(GENERIC_HDLC_VERSION) || (GENERIC_HDLC_VERSION < 4)
@@ -435,11 +354,7 @@ chan_dev_ioctl (struct net_device * dev, struct ifreq * ifr, int cmd)
 
 
 STATIC int
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-chan_attach_noop (hdlc_device * hdlc, unsigned short foo_1, unsigned short foo_2)
-#else
 chan_attach_noop (struct net_device * ndev, unsigned short foo_1, unsigned short foo_2)
-#endif
 {
     return 0;                   /* our driver has nothing to do here, show's
                                  * over, go home */
@@ -455,16 +370,12 @@ chan_get_stats (struct net_device * ndev)
     struct sbecom_chan_stats *stats;
     int         channum;
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-    channum = DEV_TO_PRIV (ndev)->channum;
-#else
     {
         struct c4_priv *priv;
 
         priv = (struct c4_priv *) dev_to_hdlc (ndev)->priv;
         channum = priv->channum;
     }
-#endif
 
     ch = c4_find_chan (channum);
     if (ch == NULL)
@@ -527,13 +438,9 @@ c4_linux_xmit (struct sk_buff * skb, struct net_device * ndev)
     const struct c4_priv *priv;
     int         rval;
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-    priv = DEV_TO_PRIV (ndev);
-#else
     hdlc_device *hdlc = dev_to_hdlc (ndev);
 
     priv = hdlc->priv;
-#endif
 
     rval = musycc_start_xmit (priv->ci, priv->channum, skb);
     return -rval;
@@ -823,18 +730,10 @@ do_create_chan (struct net_device * ndev, void *data)
     ret = mkret (c4_new_chan (ci, cp.port, cp.channum, dev));
     if (ret)
     {
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-        rtnl_unlock ();             /* needed due to Ioctl calling sequence */
-        V7 (unregister_hdlc_device) (dev_to_hdlc (dev));
-        rtnl_lock ();               /* needed due to Ioctl calling sequence */
-        OS_kfree (DEV_TO_PRIV (dev));
-        OS_kfree (dev);
-#else
         rtnl_unlock ();             /* needed due to Ioctl calling sequence */
         unregister_hdlc_device (dev);
         rtnl_lock ();               /* needed due to Ioctl calling sequence */
         free_netdev (dev);
-#endif
     }
     return ret;
 }
@@ -883,11 +782,7 @@ do_deluser (struct net_device * ndev, int lockit)
         const struct c4_priv *priv;
         int         channum;
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-        priv = DEV_TO_PRIV (ndev);
-#else
         priv = (struct c4_priv *) dev_to_hdlc (ndev)->priv;
-#endif
         ci = priv->ci;
         channum = priv->channum;
 
@@ -897,22 +792,12 @@ do_deluser (struct net_device * ndev, int lockit)
         ch->user = 0;               /* will be freed, below */
     }
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-    if (lockit)
-        rtnl_unlock ();             /* needed if Ioctl calling sequence */
-    V7 (unregister_hdlc_device) (dev_to_hdlc (ndev));
-    if (lockit)
-        rtnl_lock ();               /* needed if Ioctl calling sequence */
-    OS_kfree (DEV_TO_PRIV (ndev));
-    OS_kfree (ndev);
-#else
     if (lockit)
         rtnl_unlock ();             /* needed if Ioctl calling sequence */
     unregister_hdlc_device (ndev);
     if (lockit)
         rtnl_lock ();               /* needed if Ioctl calling sequence */
     free_netdev (ndev);
-#endif
     return 0;
 }
 
@@ -1341,9 +1226,6 @@ module_exit (c4_mod_remove);
 
 #ifndef SBE_INCLUDE_SYMBOLS
 #ifndef CONFIG_SBE_WANC24_NCOMM
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-EXPORT_NO_SYMBOLS;
-#endif
 #endif
 #endif
 
diff --git a/drivers/staging/cxt1e1/musycc.c b/drivers/staging/cxt1e1/musycc.c
index d3f5a5b..12c76a5 100644
--- a/drivers/staging/cxt1e1/musycc.c
+++ b/drivers/staging/cxt1e1/musycc.c
@@ -405,7 +405,6 @@ musycc_update_tx_thp (mch_t * ch)
 }
 
 
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,41)
 /*
  * This is the workq task executed by the OS when our queue_work() is
  * scheduled and run.  It can fire off either RX or TX ACTIVATION depending
@@ -515,7 +514,6 @@ musycc_wq_chan_restart (void *arg)      /* channel private structure */
 #endif
     }
 }
-#endif
 
 
  /*
@@ -531,7 +529,6 @@ musycc_chan_restart (mch_t * ch)
             ch->channum, ch->txd_irq_srv, ch->txd_irq_srv->status);
 #endif
 
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,41)
     /* 2.6 - find next unprocessed message, then set TX thp to it */
 #ifdef RLD_RESTART_DEBUG
     pr_info(">> musycc_chan_restart: scheduling Chan %x workQ @ %p\n", ch->channum, &ch->ch_work);
@@ -539,51 +536,9 @@ musycc_chan_restart (mch_t * ch)
     c4_wk_chan_restart (ch);        /* work queue mechanism fires off: Ref:
                                      * musycc_wq_chan_restart () */
 
-#else
-
-
-    /* 2.4 - find next unprocessed message, then set TX thp to it */
-#ifdef RLD_RESTART_DEBUG
-    pr_info(">> musycc_chan_restart: scheduling Chan %x start_tx %x\n", ch->channum, ch->ch_start_tx);
-#endif
-    /* restart transmission from background loop */
-    ch->up->up->wd_notify = WD_NOTIFY_1TX;
-#endif
 }
 
 
-#if 0
-void
-musycc_cleanup (ci_t * ci)
-{
-    mpi_t      *pi;
-    int         i, j;
-
-    /* free up driver resources */
-    ci->state = C_INIT;             /* mark as hardware not available */
-
-    for (i = 0; i < ci->max_ports; i++)
-    {
-        pi = &ci->port[i];
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,41)
-        c4_wq_port_cleanup (pi);
-#endif
-        for (j = 0; j < MUSYCC_NCHANS; j++)
-        {
-            if (pi->chan[j])
-                OS_kfree (pi->chan[j]); /* free mch_t struct */
-        }
-        OS_kfree (pi->regram_saved);
-    }
-#if 0
-    /* obsolete - watchdog is now static w/in ci_t */
-    OS_free_watchdog (ci->wd);
-#endif
-    OS_kfree (ci->iqd_p_saved);
-    OS_kfree (ci);
-}
-#endif
-
 void
 rld_put_led (mpi_t * pi, u_int32_t ledval)
 {
@@ -2008,37 +1963,13 @@ musycc_start_xmit (ci_t * ci, int channum, void *mem_token)
     atomic_add (len, &ci->tx_pending);
     ch->s.tx_packets++;
     ch->s.tx_bytes += len;
-#if 0
-    spin_unlock_irqrestore (&ch->ch_txlock, flags);   /* allow pending
-                                                       * interrupt to sneak
-                                                       * thru */
-#endif
-
     /*
      * If an ONR was seen, then channel requires poking to restart
      * transmission.
      */
     if (ch->ch_start_tx)
     {
-#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,5,41)
-        SD_SEM_TAKE (&ci->sem_wdbusy, "_wd_");  /* only 1 thru here, per
-                                                 * board */
-        if ((ch->ch_start_tx == CH_START_TX_ONR) && (ch->p.chan_mode == CFG_CH_PROTO_TRANS))
-        {
-            /* ONR restart transmission from background loop */
-            ci->wd_notify = WD_NOTIFY_ONR;      /* enabled global watchdog
-                                                 * scan-thru  */
-        } else
-        {
-            /* start first transmission from background loop */
-            ci->wd_notify = WD_NOTIFY_1TX;      /* enabled global watchdog
-                                                 * scan-thru  */
-        }
         musycc_chan_restart (ch);
-        SD_SEM_GIVE (&ci->sem_wdbusy);
-#else
-        musycc_chan_restart (ch);
-#endif
     }
 #ifdef SBE_WAN256T3_ENABLE
     wan256t3_led (ci, LED_TX, LEDV_G);
@@ -2047,139 +1978,4 @@ musycc_start_xmit (ci_t * ci, int channum, void *mem_token)
 }
 
 
-#if 0
-int
-musycc_set_chan (ci_t * ci, int channum, struct sbecom_chan_param * p)
-{
-    mch_t      *ch;
-    int         rok = 0;
-    int         n = 0;
-
-    if (channum < 0 || channum >= (MUSYCC_NPORTS * MUSYCC_NCHANS))      /* sanity chk param */
-        return ECHRNG;
-    if (!(ch = sd_find_chan (ci, channum)))
-        return ENOENT;
-    if (ch->channum != p->channum)
-        return EINVAL;
-    if (sd_line_is_ok (ch->user))
-    {
-        rok = 1;
-        sd_line_is_down (ch->user);
-    }
-    if (ch->state == UP &&          /* bring down in current configuration */
-        (ch->p.status != p->status ||
-         ch->p.chan_mode != p->chan_mode ||
-         ch->p.intr_mask != p->intr_mask ||
-         ch->txd_free < ch->txd_num))
-    {
-        if ((n = musycc_chan_down (ci, channum)))
-            return n;
-        if (ch->p.mode_56k != p->mode_56k)
-        {
-            ch->p = *p;             /* copy in new parameters */
-            musycc_update_timeslots (&ci->port[ch->channum / MUSYCC_NCHANS]);
-        } else
-            ch->p = *p;             /* copy in new parameters */
-        if ((n = musycc_chan_up (ci, channum)))
-            return n;
-        sd_enable_xmit (ch->user);  /* re-enable to catch flow controlled
-                                     * channel */
-    } else
-    {
-        if (ch->p.mode_56k != p->mode_56k)
-        {
-            ch->p = *p;             /* copy in new parameters */
-            musycc_update_timeslots (&ci->port[ch->channum / MUSYCC_NCHANS]);
-        } else
-            ch->p = *p;             /* copy in new parameters */
-    }
-
-    if (rok)
-        sd_line_is_up (ch->user);
-    return 0;
-}
-#endif
-
-
-int
-musycc_get_chan (ci_t * ci, int channum, struct sbecom_chan_param * p)
-{
-    mch_t      *ch;
-
-#if 0
-    if (channum < 0 || channum >= (MUSYCC_NPORTS * MUSYCC_NCHANS))      /* sanity chk param */
-        return ECHRNG;
-#endif
-    if (!(ch = sd_find_chan (ci, channum)))
-        return ENOENT;
-    *p = ch->p;
-    return 0;
-}
-
-
-int
-musycc_get_chan_stats (ci_t * ci, int channum, struct sbecom_chan_stats * p)
-{
-    mch_t      *ch;
-
-    if (channum < 0 || channum >= (MUSYCC_NPORTS * MUSYCC_NCHANS))      /* sanity chk param */
-        return ECHRNG;
-    if (!(ch = sd_find_chan (ci, channum)))
-        return ENOENT;
-    *p = ch->s;
-    p->tx_pending = atomic_read (&ch->tx_pending);
-    return 0;
-}
-
-
-
-#ifdef SBE_WAN256T3_ENABLE
-int
-musycc_chan_down (ci_t * ci, int channum)
-{
-    mch_t      *ch;
-    mpi_t      *pi;
-    int         i, gchan;
-
-    if (!(ch = sd_find_chan (ci, channum)))
-        return EINVAL;
-    pi = ch->up;
-    gchan = ch->gchan;
-
-    /* Deactivate the channel */
-    musycc_serv_req (pi, SR_CHANNEL_DEACTIVATE | SR_RX_DIRECTION | gchan);
-    ch->ch_start_rx = 0;
-    musycc_serv_req (pi, SR_CHANNEL_DEACTIVATE | SR_TX_DIRECTION | gchan);
-    ch->ch_start_tx = 0;
-
-    if (ch->state == DOWN)
-        return 0;
-    ch->state = DOWN;
-
-    pi->regram->thp[gchan] = 0;
-    pi->regram->tmp[gchan] = 0;
-    pi->regram->rhp[gchan] = 0;
-    pi->regram->rmp[gchan] = 0;
-    FLUSH_MEM_WRITE ();
-    for (i = 0; i < ch->txd_num; i++)
-    {
-        if (ch->mdt[i].mem_token != 0)
-            OS_mem_token_free (ch->mdt[i].mem_token);
-    }
-
-    for (i = 0; i < ch->rxd_num; i++)
-    {
-        if (ch->mdr[i].mem_token != 0)
-            OS_mem_token_free (ch->mdr[i].mem_token);
-    }
-
-    OS_kfree (ch->mdt);
-    ch->mdt = 0;
-    OS_kfree (ch->mdr);
-    ch->mdr = 0;
-
-    return 0;
-}
-#endif
-
 /*** End-of-File ***/
diff --git a/drivers/staging/cxt1e1/pmc93x6_eeprom.c b/drivers/staging/cxt1e1/pmc93x6_eeprom.c
index 1c8dfb8..62b12fb 100644
--- a/drivers/staging/cxt1e1/pmc93x6_eeprom.c
+++ b/drivers/staging/cxt1e1/pmc93x6_eeprom.c
@@ -500,11 +500,7 @@ pmc_init_seeprom (u_int32_t addr, u_int32_t serialNum)
     time_t      createTime;
     int         i;
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-    createTime = CURRENT_TIME;
-#else
     createTime = get_seconds ();
-#endif
 
     /* use template data */
     for (i = 0; i < sizeof (FLD_TYPE2); ++i)
diff --git a/drivers/staging/cxt1e1/pmcc4.h b/drivers/staging/cxt1e1/pmcc4.h
index 26c1f0e..e288a0a 100644
--- a/drivers/staging/cxt1e1/pmcc4.h
+++ b/drivers/staging/cxt1e1/pmcc4.h
@@ -117,12 +117,6 @@ extern      "C"
 
 #include "pmcc4_private.h"
 
-#if !(LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0))
-char       *get_hdlc_name (hdlc_device *);
-
-#endif
-
-
 /*
  * external interface
  */
diff --git a/drivers/staging/cxt1e1/pmcc4_drv.c b/drivers/staging/cxt1e1/pmcc4_drv.c
index 333cf26..9f730e6 100644
--- a/drivers/staging/cxt1e1/pmcc4_drv.c
+++ b/drivers/staging/cxt1e1/pmcc4_drv.c
@@ -119,12 +119,10 @@ char        OSSIid_pmcc4_drvc[] =
 #define KERN_WARN KERN_WARNING
 
 /* forward references */
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,41)
 status_t    c4_wk_chan_init (mpi_t *, mch_t *);
 void        c4_wq_port_cleanup (mpi_t *);
 status_t    c4_wq_port_init (mpi_t *);
 
-#endif
 int         c4_loop_port (ci_t *, int, u_int8_t);
 status_t    c4_set_port (ci_t *, int);
 status_t    musycc_chan_down (ci_t *, int);
@@ -533,145 +531,15 @@ checkPorts (ci_t * ci)
 STATIC void
 c4_watchdog (ci_t * ci)
 {
-#if 0
-    //unsigned long flags;
-#endif
-
     if (drvr_state != SBE_DRVR_AVAILABLE)
     {
         if (log_level >= LOG_MONITOR)
             pr_info("drvr not available (%x)\n", drvr_state);
         return;
     }
-#if 0
-    SD_SEM_TAKE (&ci->sem_wdbusy, "_wd_");    /* only 1 thru here, per
-                                               * board */
-#endif
-
     ci->wdcount++;
     checkPorts (ci);
-#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,5,41)
-    if (ci->wd_notify)
-    {                               /* is there a state change to search for */
-        int         port, gchan;
-
-        ci->wd_notify = 0;          /* reset notification */
-        for (gchan = 0; gchan < MUSYCC_NCHANS; gchan++)
-        {
-            for (port = 0; port < ci->max_port; port++)
-            {
-                mch_t      *ch = ci->port[port].chan[gchan];
-
-                if (!ch || ci->state != C_RUNNING)      /* state changed while
-                                                         * acquiring semaphore */
-                    break;
-                if (ch->state == UP)/* channel must be set up */
-                {
-#if 0
-#ifdef RLD_TRANS_DEBUG
-                    if (1 || log_level >= LOG_MONITOR)
-#else
-                    if (log_level >= LOG_MONITOR)
-#endif
-                        pr_info("%s: watchdog reviving Port %d Channel %d [%d] sts %x/%x, start_TX %x free %x start_RX %x\n",
-                         ci->devname, ch->channum, port, gchan, ch->channum,
-                                ch->p.status, ch->status,
-                            ch->ch_start_tx, ch->txd_free, ch->ch_start_rx);
-#endif
-
-                    /**********************************/
-                    /** check for RX restart request **/
-                    /**********************************/
-
-                    if (ch->ch_start_rx &&
-                        (ch->status & RX_ENABLED))      /* requires start on
-                                                         * enabled RX */
-                    {
-                        ch->ch_start_rx = 0;    /* we are restarting RX... */
-#ifdef RLD_TRANS_DEBUG
-                        pr_info("++ c4_watchdog() CHAN RX ACTIVATE: chan %d\n",
-                                ch->channum);
-#endif
-#ifdef RLD_RXACT_DEBUG
-                        {
-                            struct mdesc *md;
-                            static int  hereb4 = 7;
-
-                            if (hereb4)
-                            {
-                                hereb4--;
-                                md = &ch->mdr[ch->rxix_irq_srv];
-                                pr_info("++ c4_watchdog[%d] CHAN RX ACTIVATE: rxix_irq_srv %d, md %p sts %x, rxpkt %lu\n",
-                                        ch->channum, ch->rxix_irq_srv, md, le32_to_cpu (md->status), ch->s.rx_packets);
-                                musycc_dump_rxbuffer_ring (ch, 1);      /* RLD DEBUG */
-                            }
-                        }
-#endif
-                        musycc_serv_req (ch->up, SR_CHANNEL_ACTIVATE | SR_RX_DIRECTION | gchan);
-                    }
-                    /**********************************/
-                    /** check for TX restart request **/
-                    /**********************************/
-
-                    if (ch->ch_start_tx &&
-                        (ch->status & TX_ENABLED))      /* requires start on
-                                                         * enabled TX */
-                    {
-                        struct mdesc *md;
-
-                        /*
-                         * find next unprocessed message, then set TX thp to
-                         * it
-                         */
-                        musycc_update_tx_thp (ch);
-
-#if 0
-                        spin_lock_irqsave (&ch->ch_txlock, flags);
-#endif
-                        md = ch->txd_irq_srv;
-                        if (!md)
-                        {
-                            pr_info("-- c4_watchdog[%d]: WARNING, starting NULL md\n",
-                                    ch->channum);
-                            pr_info("--   chan %d txd_irq_srv %p sts %x usr_add %p sts %x, txpkt %lu\n",
-                                    ch->channum, ch->txd_irq_srv, le32_to_cpu ((struct mdesc *) (ch->txd_irq_srv)->status),
-                                    ch->txd_usr_add, le32_to_cpu ((struct mdesc *) (ch->txd_usr_add)->status),
-                                    ch->s.tx_packets);
-#if 0
-                            spin_unlock_irqrestore (&ch->ch_txlock, flags);
-#endif
-                        } else if (md->data && ((le32_to_cpu (md->status)) & MUSYCC_TX_OWNED))
-                        {
-#ifdef RLD_TRANS_DEBUG
-                            pr_info("++ c4_watchdog[%d] CHAN TX ACTIVATE: start_tx %x\n",
-                                    ch->channum, ch->ch_start_tx);
-#endif
-                            ch->ch_start_tx = 0;        /* we are restarting
-                                                         * TX... */
-#if 0
-                            spin_unlock_irqrestore (&ch->ch_txlock, flags);   /* allow interrupts for
-                                                                               * service request */
-#endif
-                            musycc_serv_req (ch->up, SR_CHANNEL_ACTIVATE | SR_TX_DIRECTION | gchan);
-#ifdef RLD_TRANS_DEBUG
-                            if (1 || log_level >= LOG_MONITOR)
-#else
-                            if (log_level >= LOG_MONITOR)
-#endif
-                                pr_info("++ SACK[P%d/C%d] ack'd, continuing...\n",
-                                        ch->up->portnum, ch->channum);
-                        }
-                    }
-                }
-            }
-        }
-    }
-#else
     ci->wd_notify = 0;
-#endif
-#if 0
-    SD_SEM_GIVE (&ci->sem_wdbusy);/* release per-board hold */
-#endif
 }
 
 
@@ -690,9 +558,7 @@ c4_cleanup (void)
         for (portnum = 0; portnum < ci->max_port; portnum++)
         {
             pi = &ci->port[portnum];
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,41)
             c4_wq_port_cleanup (pi);
-#endif
             for (j = 0; j < MUSYCC_NCHANS; j++)
             {
                 if (pi->chan[j])
@@ -700,10 +566,6 @@ c4_cleanup (void)
             }
             OS_kfree (pi->regram_saved);
         }
-#if 0
-        /* obsolete - watchdog is now static w/in ci_t */
-        OS_free_watchdog (ci->wd);
-#endif
         OS_kfree (ci->iqd_p_saved);
         OS_kfree (ci);
         ci = next;                  /* cleanup next board, if any */
@@ -1145,7 +1007,6 @@ c4_set_port (ci_t * ci, int portnum)
         return EBUSY;               /* group needs initialization only for
                                      * first channel of a group */
 
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,41)
     {
         status_t    ret;
 
@@ -1153,7 +1014,6 @@ c4_set_port (ci_t * ci, int portnum)
                                                  * workqueue_struct */
             return (ret);
     }
-#endif
 
     init_comet (ci, pi->cometbase, pp->port_mode, 1 /* clockmaster == true */ , pp->portP);
     clck = pci_read_32 ((u_int32_t *) &ci->cpldbase->mclk) & PMCC4_CPLD_MCLK_MASK;
@@ -1269,14 +1129,12 @@ c4_new_chan (ci_t * ci, int portnum, int channum, void *user)
     spin_lock_init (&ch->ch_rxlock);
     spin_lock_init (&ch->ch_txlock);
 
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,41)
     {
         status_t    ret;
 
         if ((ret = c4_wk_chan_init (pi, ch)))
             return ret;
     }
-#endif
 
     /* save off interface assignments which bound a board */
     if (ci->first_if == 0)          /* first channel registered is assumed to
@@ -1705,31 +1563,23 @@ sbecom_get_brdinfo (ci_t * ci, struct sbe_brd_info * bip, u_int8_t *bsn)
 
     if (ci->first_if)
     {
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-        np = (char *) hdlc_to_name (ci->first_if);
-#else
         {
             struct net_device *dev;
 
             dev = (struct net_device *) ci->first_if;
             np = (char *) dev->name;
         }
-#endif
         strncpy (bip->first_iname, np, CHNM_STRLEN - 1);
     } else
         strcpy (bip->first_iname, "<NULL>");
     if (ci->last_if)
     {
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-        np = (char *) hdlc_to_name (ci->last_if);
-#else
         {
             struct net_device *dev;
 
             dev = (struct net_device *) ci->last_if;
             np = (char *) dev->name;
         }
-#endif
         strncpy (bip->last_iname, np, CHNM_STRLEN - 1);
     } else
         strcpy (bip->last_iname, "<NULL>");
@@ -1763,11 +1613,7 @@ c4_get_iidinfo (ci_t * ci, struct sbe_iid_info * iip)
     if (!(dev = getuserbychan (iip->channum)))
         return ENOENT;
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-    np = (char *) hdlc_to_name (dev_to_hdlc (dev));
-#else
     np = dev->name;
-#endif
     strncpy (iip->iname, np, CHNM_STRLEN - 1);
     return 0;
 }
@@ -1826,11 +1672,7 @@ c4_ebus_intr_th_handler (void *devp)
     pci_write_32 ((u_int32_t *) &ci->reg->glcd, GCD_MAGIC | MUSYCC_GCD_INTB_DISABLE);
 #endif
 
-#if LINUX_VERSION_CODE <= KERNEL_VERSION(2,4,20)
-    return;
-#else
     return IRQ_RETVAL (handled);
-#endif
 }
 
 
diff --git a/drivers/staging/cxt1e1/sbecom_inline_linux.h b/drivers/staging/cxt1e1/sbecom_inline_linux.h
index c65172d..5a72cb5 100644
--- a/drivers/staging/cxt1e1/sbecom_inline_linux.h
+++ b/drivers/staging/cxt1e1/sbecom_inline_linux.h
@@ -48,9 +48,6 @@
 #else
 #include <linux/types.h>
 #include <linux/version.h>
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,18)
-#include <linux/config.h>
-#endif
 #if defined(CONFIG_SMP) && ! defined(__SMP__)
 #define __SMP__
 #endif
@@ -60,12 +57,8 @@
 
 #ifdef MODULE
 #ifdef MODVERSIONS
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-#include <linux/modversions.h>
-#else
 #include <config/modversions.h>
 #endif
-#endif
 #include <linux/module.h>
 #endif
 #endif
@@ -260,11 +253,7 @@ OS_sem_free (void *sem)
 struct watchdog
 {
     struct timer_list h;
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-    struct tq_struct tq;
-#else
     struct work_struct work;
-#endif
     void       *softc;
     void        (*func) (void *softc);
     int         ticks;
diff --git a/drivers/staging/rtl8192e/ieee80211/dot11d.c b/drivers/staging/rtl8192e/ieee80211/dot11d.c
index 908f605..6bbf091 100644
--- a/drivers/staging/rtl8192e/ieee80211/dot11d.c
+++ b/drivers/staging/rtl8192e/ieee80211/dot11d.c
@@ -218,22 +218,4 @@ int ToLegalChannel(
 
 	return default_chn;
 }
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0))
-//EXPORT_SYMBOL(Dot11d_Init);
-//EXPORT_SYMBOL(Dot11d_Reset);
-//EXPORT_SYMBOL(Dot11d_UpdateCountryIe);
-//EXPORT_SYMBOL(DOT11D_GetMaxTxPwrInDbm);
-//EXPORT_SYMBOL(DOT11D_ScanComplete);
-//EXPORT_SYMBOL(IsLegalChannel);
-//EXPORT_SYMBOL(ToLegalChannel);
-#else
-EXPORT_SYMBOL_NOVERS(Dot11d_Init);
-EXPORT_SYMBOL_NOVERS(Dot11d_Reset);
-EXPORT_SYMBOL_NOVERS(Dot11d_UpdateCountryIe);
-EXPORT_SYMBOL_NOVERS(DOT11D_GetMaxTxPwrInDbm);
-EXPORT_SYMBOL_NOVERS(DOT11D_ScanComplete);
-EXPORT_SYMBOL_NOVERS(IsLegalChannel);
-EXPORT_SYMBOL_NOVERS(ToLegalChannel);
-#endif
-
 #endif
diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211.h b/drivers/staging/rtl8192e/ieee80211/ieee80211.h
index 50728f6..02594fd 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211.h
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211.h
@@ -27,12 +27,7 @@
 #include <linux/kernel.h>   /* ARRAY_SIZE */
 #include <linux/version.h>
 #include <linux/module.h>
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0))
 #include <linux/jiffies.h>
-#else
-#include <linux/jffs.h>
-#include <linux/tqueue.h>
-#endif
 #include <linux/timer.h>
 #include <linux/sched.h>
 #include <linux/semaphore.h>
@@ -44,12 +39,6 @@
 #include "rtl819x_BA.h"
 #include "rtl819x_TS.h"
 
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20))
-#ifndef bool
-typedef enum{false = 0, true} bool;
-#endif
-#endif
-
 #ifndef IW_MODE_MONITOR
 #define IW_MODE_MONITOR 6
 #endif
@@ -58,23 +47,7 @@ typedef enum{false = 0, true} bool;
 #define IWEVCUSTOM 0x8c02
 #endif
 
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0))
-#ifndef __bitwise
-#define __bitwise __attribute__((bitwise))
-#endif
 typedef __u16  __le16;
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,4,27))
-struct iw_spy_data{
-	/* --- Standard spy support --- */
-	int 			spy_number;
-	u_char 			spy_address[IW_MAX_SPY][ETH_ALEN];
-	struct iw_quality	spy_stat[IW_MAX_SPY];
-	/* --- Enhanced spy support (event) */
-	struct iw_quality	spy_thr_low; /* Low threshold */
-	struct iw_quality	spy_thr_high; /* High threshold */
-	u_char			spy_thr_under[IW_MAX_SPY];
-};
-#endif
 #endif
 
 #ifndef container_of
@@ -428,46 +401,9 @@ typedef struct ieee_param {
 #define IW_QUAL_NOISE_UPDATED  0x4
 #endif
 
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0))
-static inline void tq_init(struct tq_struct * task, void(*func)(void *), void *data)
-{
-	task->routine = func;
-	task->data 	= data;
-	//task->next = NULL;
-	INIT_LIST_HEAD(&task->list);
-	task->sync = 0;
-}
-#endif
-
 // linux under 2.6.9 release may not support it, so modify it for common use
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,9))
-//#define MSECS(t)	(1000 * ((t) / HZ) + 1000 * ((t) % HZ) / HZ)
-#define MSECS(t)	(HZ * ((t) / 1000) + (HZ * ((t) % 1000)) / 1000)
-static inline unsigned long msleep_interruptible_rsl(unsigned int msecs)
-{
-         unsigned long timeout = MSECS(msecs) + 1;
-
-         while (timeout) {
-                 set_current_state(TASK_INTERRUPTIBLE);
-                 timeout = schedule_timeout(timeout);
-         }
-         return timeout;
-}
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,4,31))
-static inline void msleep(unsigned int msecs)
-{
-         unsigned long timeout = MSECS(msecs) + 1;
-
-         while (timeout) {
-                 set_current_state(TASK_UNINTERRUPTIBLE);
-                 timeout = schedule_timeout(timeout);
-         }
-}
-#endif
-#else
 #define MSECS(t) msecs_to_jiffies(t)
 #define msleep_interruptible_rsl  msleep_interruptible
-#endif
 
 #define IEEE80211_DATA_LEN		2304
 /* Maximum size for the MA-UNITDATA primitive, 802.11 standard section
@@ -1747,21 +1683,6 @@ enum ieee80211_state {
 #define IEEE80211_52GHZ_CHANNELS (IEEE80211_52GHZ_MAX_CHANNEL - \
                                   IEEE80211_52GHZ_MIN_CHANNEL + 1)
 
-#if (LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,11))
-extern inline int is_multicast_ether_addr(const u8 *addr)
-{
-        return ((addr[0] != 0xff) && (0x01 & addr[0]));
-}
-#endif
-
-#if (LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,13))
-extern inline int is_broadcast_ether_addr(const u8 *addr)
-{
-	return ((addr[0] == 0xff) && (addr[1] == 0xff) && (addr[2] == 0xff) &&   \
-		(addr[3] == 0xff) && (addr[4] == 0xff) && (addr[5] == 0xff));
-}
-#endif
-
 typedef struct tx_pending_t{
 	int frag;
 	struct ieee80211_txb *txb;
@@ -1838,11 +1759,7 @@ typedef struct _RT_POWER_SAVE_CONTROL
 	bool				bIPSModeBackup;
 	bool				bSwRfProcessing;
 	RT_RF_POWER_STATE	eInactivePowerState;
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
 	struct work_struct 	InactivePsWorkItem;
-#else
-	struct tq_struct	InactivePsWorkItem;
-#endif
 	struct timer_list	InactivePsTimer;
 
 	// Return point for join action
@@ -2329,36 +2246,20 @@ struct ieee80211_device {
 
 	/* used if IEEE_SOFTMAC_BEACONS is set */
 	struct timer_list beacon_timer;
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
         struct work_struct associate_complete_wq;
         struct work_struct associate_procedure_wq;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20)
         struct delayed_work softmac_scan_wq;
         struct delayed_work associate_retry_wq;
 	 struct delayed_work start_ibss_wq;
 	 struct delayed_work hw_wakeup_wq;
 	struct delayed_work hw_sleep_wq;
-#else
         struct work_struct softmac_scan_wq;
         struct work_struct associate_retry_wq;
 	struct work_struct start_ibss_wq;
 	struct work_struct hw_wakeup_wq;
 	struct work_struct hw_sleep_wq;
-#endif
         struct work_struct wx_sync_scan_wq;
         struct workqueue_struct *wq;
-#else
-	/* used for periodly scan */
-	struct timer_list scan_timer;
-
-	struct tq_struct associate_complete_wq;
-	struct tq_struct associate_retry_wq;
-	struct tq_struct start_ibss_wq;
-	struct tq_struct associate_procedure_wq;
-	struct tq_struct softmac_scan_wq;
-	struct tq_struct wx_sync_scan_wq;
-
-#endif
         // Qos related. Added by Annie, 2005-11-01.
         //STA_QOS  StaQos;
 
@@ -2557,11 +2458,7 @@ struct ieee80211_device {
 
 static inline void *ieee80211_priv(struct net_device *dev)
 {
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
 	return ((struct ieee80211_device *)netdev_priv(dev))->priv;
-#else
-	return ((struct ieee80211_device *)dev->priv)->priv;
-#endif
 }
 
 extern inline int ieee80211_is_empty_essid(const char *essid, int essid_len)
@@ -2814,11 +2711,7 @@ extern int ieee80211_wx_get_freq(struct ieee80211_device *ieee, struct iw_reques
 			     union iwreq_data *wrqu, char *b);
 
 //extern void ieee80211_wx_sync_scan_wq(struct ieee80211_device *ieee);
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
 extern void ieee80211_wx_sync_scan_wq(struct work_struct *work);
-#else
- extern void ieee80211_wx_sync_scan_wq(struct ieee80211_device *ieee);
-#endif
 
 
 extern int ieee80211_wx_set_rawtx(struct ieee80211_device *ieee,
diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt.c
index d5aa9af..ae50379 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt.c
@@ -243,23 +243,3 @@ void ieee80211_crypto_deinit(void)
 	kfree(hcrypt);
 }
 
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0))
-//EXPORT_SYMBOL(ieee80211_crypt_deinit_entries);
-//EXPORT_SYMBOL(ieee80211_crypt_deinit_handler);
-//EXPORT_SYMBOL(ieee80211_crypt_delayed_deinit);
-
-//EXPORT_SYMBOL(ieee80211_register_crypto_ops);
-//EXPORT_SYMBOL(ieee80211_unregister_crypto_ops);
-//EXPORT_SYMBOL(ieee80211_get_crypto_ops);
-#else
-EXPORT_SYMBOL_NOVERS(ieee80211_crypt_deinit_entries);
-EXPORT_SYMBOL_NOVERS(ieee80211_crypt_deinit_handler);
-EXPORT_SYMBOL_NOVERS(ieee80211_crypt_delayed_deinit);
-
-EXPORT_SYMBOL_NOVERS(ieee80211_register_crypto_ops);
-EXPORT_SYMBOL_NOVERS(ieee80211_unregister_crypto_ops);
-EXPORT_SYMBOL_NOVERS(ieee80211_get_crypto_ops);
-#endif
-
-//module_init(ieee80211_crypto_init);
-//module_exit(ieee80211_crypto_deinit);
diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt.h b/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt.h
index a84df4b..ca7dd0d 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt.h
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt.h
@@ -82,12 +82,4 @@ void ieee80211_crypt_deinit_entries(struct ieee80211_device *, int);
 void ieee80211_crypt_deinit_handler(unsigned long);
 void ieee80211_crypt_delayed_deinit(struct ieee80211_device *ieee,
 				    struct ieee80211_crypt_data **crypt);
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0))
-#define offset_in_page(p) ((unsigned long)(p) & ~PAGE_MASK)
-#endif
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,4,31))
-#define crypto_alloc_tfm crypto_alloc_tfm_rsl
-#define crypto_free_tfm crypto_free_tfm_rsl
-#endif
-
 #endif
diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_ccmp.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_ccmp.c
index 7165c4c..a4e21cb 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_ccmp.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_ccmp.c
@@ -24,18 +24,9 @@
 
 #include "ieee80211.h"
 
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0))
-#include "rtl_crypto.h"
-#else
 #include <linux/crypto.h>
-#endif
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
-    #include <asm/scatterlist.h>
-#else
     #include <linux/scatterlist.h>
-#endif
-//#include <asm/scatterlist.h>
 
 MODULE_AUTHOR("Jouni Malinen");
 MODULE_DESCRIPTION("Host AP crypt: CCMP");
@@ -75,21 +66,7 @@ struct ieee80211_ccmp_data {
 void ieee80211_ccmp_aes_encrypt(struct crypto_tfm *tfm,
 			     const u8 pt[16], u8 ct[16])
 {
-#if((LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21)) && (!OPENSUSE_SLED))
-	struct scatterlist src, dst;
-
-	src.page = virt_to_page(pt);
-	src.offset = offset_in_page(pt);
-	src.length = AES_BLOCK_LEN;
-
-	dst.page = virt_to_page(ct);
-	dst.offset = offset_in_page(ct);
-	dst.length = AES_BLOCK_LEN;
-
-	crypto_cipher_encrypt(tfm, &dst, &src, AES_BLOCK_LEN);
-#else
 	crypto_cipher_encrypt_one((void*)tfm, ct, pt);
-#endif
 }
 
 static void * ieee80211_ccmp_init(int key_idx)
@@ -101,14 +78,6 @@ static void * ieee80211_ccmp_init(int key_idx)
 		goto fail;
 	priv->key_idx = key_idx;
 
-#if((LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21)) && (!OPENSUSE_SLED))
-	priv->tfm = crypto_alloc_tfm("aes", 0);
-	if (priv->tfm == NULL) {
-		printk(KERN_DEBUG "ieee80211_crypt_ccmp: could not allocate "
-		       "crypto API aes\n");
-		goto fail;
-	}
-       #else
        priv->tfm = (void*)crypto_alloc_cipher("aes", 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(priv->tfm)) {
 		printk(KERN_DEBUG "ieee80211_crypt_ccmp: could not allocate "
@@ -116,17 +85,12 @@ static void * ieee80211_ccmp_init(int key_idx)
 		priv->tfm = NULL;
 		goto fail;
 	}
-	#endif
 	return priv;
 
 fail:
 	if (priv) {
 		if (priv->tfm)
-			#if(LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21))
-			crypto_free_tfm(priv->tfm);
-                    #else
 			crypto_free_cipher((void*)priv->tfm);
-		      #endif
 		kfree(priv);
 	}
 
@@ -138,11 +102,7 @@ static void ieee80211_ccmp_deinit(void *priv)
 {
 	struct ieee80211_ccmp_data *_priv = priv;
 	if (_priv && _priv->tfm)
-#if(LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21))
-		crypto_free_tfm(_priv->tfm);
-#else
 		crypto_free_cipher((void*)_priv->tfm);
-#endif
 	kfree(priv);
 }
 
@@ -528,11 +488,3 @@ void ieee80211_crypto_ccmp_exit(void)
 	ieee80211_unregister_crypto_ops(&ieee80211_crypt_ccmp);
 }
 
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0))
-//EXPORT_SYMBOL(ieee80211_ccmp_null);
-#else
-EXPORT_SYMBOL_NOVERS(ieee80211_ccmp_null);
-#endif
-
-//module_init(ieee80211_crypto_ccmp_init);
-//module_exit(ieee80211_crypto_ccmp_exit);
diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_tkip.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_tkip.c
index 65f4889..14ca610 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_tkip.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_tkip.c
@@ -24,17 +24,8 @@
 #include "ieee80211.h"
 
 
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0))
-#include "rtl_crypto.h"
-#else
 #include <linux/crypto.h>
-#endif
-//#include <asm/scatterlist.h>
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
-    #include <asm/scatterlist.h>
-#else
-        #include <linux/scatterlist.h>
-#endif
+#include <linux/scatterlist.h>
 
 #include <linux/crc32.h>
 
@@ -68,17 +59,10 @@ struct ieee80211_tkip_data {
 	u32 dot11RSNAStatsTKIPLocalMICFailures;
 
 	int key_idx;
-#if((LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,21)) || (OPENSUSE_SLED))
 	struct crypto_blkcipher *rx_tfm_arc4;
 	struct crypto_hash *rx_tfm_michael;
 	struct crypto_blkcipher *tx_tfm_arc4;
 	struct crypto_hash *tx_tfm_michael;
-#else
-	struct crypto_tfm *tx_tfm_arc4;
-	struct crypto_tfm *tx_tfm_michael;
-	struct crypto_tfm *rx_tfm_arc4;
-	struct crypto_tfm *rx_tfm_michael;
-#endif
 	/* scratch buffers for virt_to_page() (crypto API) */
 	u8 rx_hdr[16], tx_hdr[16];
 };
@@ -91,35 +75,6 @@ static void * ieee80211_tkip_init(int key_idx)
 	if (priv == NULL)
 		goto fail;
 	priv->key_idx = key_idx;
-#if((LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21)) && (!OPENSUSE_SLED))
-	priv->tx_tfm_arc4 = crypto_alloc_tfm("arc4", 0);
-	if (priv->tx_tfm_arc4 == NULL) {
-		printk(KERN_DEBUG "ieee80211_crypt_tkip: could not allocate "
-				"crypto API arc4\n");
-		goto fail;
-	}
-
-	priv->tx_tfm_michael = crypto_alloc_tfm("michael_mic", 0);
-	if (priv->tx_tfm_michael == NULL) {
-		printk(KERN_DEBUG "ieee80211_crypt_tkip: could not allocate "
-				"crypto API michael_mic\n");
-		goto fail;
-	}
-
-	priv->rx_tfm_arc4 = crypto_alloc_tfm("arc4", 0);
-	if (priv->rx_tfm_arc4 == NULL) {
-		printk(KERN_DEBUG "ieee80211_crypt_tkip: could not allocate "
-				"crypto API arc4\n");
-		goto fail;
-	}
-
-	priv->rx_tfm_michael = crypto_alloc_tfm("michael_mic", 0);
-	if (priv->rx_tfm_michael == NULL) {
-		printk(KERN_DEBUG "ieee80211_crypt_tkip: could not allocate "
-				"crypto API michael_mic\n");
-		goto fail;
-	}
-#else
 	priv->tx_tfm_arc4 = crypto_alloc_blkcipher("ecb(arc4)", 0,
 			CRYPTO_ALG_ASYNC);
 	if (IS_ERR(priv->tx_tfm_arc4)) {
@@ -155,22 +110,10 @@ static void * ieee80211_tkip_init(int key_idx)
 		priv->rx_tfm_michael = NULL;
 		goto fail;
 	}
-#endif
 	return priv;
 
 fail:
 	if (priv) {
-#if((LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21)) && (!OPENSUSE_SLED))
-		if (priv->tx_tfm_michael)
-			crypto_free_tfm(priv->tx_tfm_michael);
-		if (priv->tx_tfm_arc4)
-			crypto_free_tfm(priv->tx_tfm_arc4);
-		if (priv->rx_tfm_michael)
-			crypto_free_tfm(priv->rx_tfm_michael);
-		if (priv->rx_tfm_arc4)
-			crypto_free_tfm(priv->rx_tfm_arc4);
-
-#else
 		if (priv->tx_tfm_michael)
 			crypto_free_hash(priv->tx_tfm_michael);
 		if (priv->tx_tfm_arc4)
@@ -179,7 +122,6 @@ fail:
 			crypto_free_hash(priv->rx_tfm_michael);
 		if (priv->rx_tfm_arc4)
 			crypto_free_blkcipher(priv->rx_tfm_arc4);
-#endif
 		kfree(priv);
 	}
 
@@ -190,16 +132,6 @@ fail:
 static void ieee80211_tkip_deinit(void *priv)
 {
 	struct ieee80211_tkip_data *_priv = priv;
-#if((LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21)) && (!OPENSUSE_SLED))
-	if (_priv->tx_tfm_michael)
-		crypto_free_tfm(_priv->tx_tfm_michael);
-	if (_priv->tx_tfm_arc4)
-		crypto_free_tfm(_priv->tx_tfm_arc4);
-	if (_priv->rx_tfm_michael)
-		crypto_free_tfm(_priv->rx_tfm_michael);
-	if (_priv->rx_tfm_arc4)
-		crypto_free_tfm(_priv->rx_tfm_arc4);
-#else
 	if (_priv) {
 		if (_priv->tx_tfm_michael)
 			crypto_free_hash(_priv->tx_tfm_michael);
@@ -210,7 +142,6 @@ static void ieee80211_tkip_deinit(void *priv)
 		if (_priv->rx_tfm_arc4)
 			crypto_free_blkcipher(_priv->rx_tfm_arc4);
 	}
-#endif
 	kfree(priv);
 }
 
@@ -381,10 +312,8 @@ static int ieee80211_tkip_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	struct ieee80211_hdr_4addr *hdr;
 	cb_desc *tcb_desc = (cb_desc *)(skb->cb + MAX_DEV_ADDR_SIZE);
 
-	#if((LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,21)) || (OPENSUSE_SLED))
 	struct blkcipher_desc desc = {.tfm = tkey->tx_tfm_arc4};
 	int ret = 0;
-	#endif
 	u8 rc4key[16],  *icv;
 	u32 crc;
 	struct scatterlist sg;
@@ -447,32 +376,14 @@ printk("%x\n", ((u32*)tkey->key)[7]);
 	if (!tcb_desc->bHwSec)
 	{
 		icv = skb_put(skb, 4);
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0))
 		crc = ~crc32_le(~0, pos, len);
-#else
-		crc = ~ether_crc_le(len, pos);
-#endif
 		icv[0] = crc;
 		icv[1] = crc >> 8;
 		icv[2] = crc >> 16;
 		icv[3] = crc >> 24;
-#if((LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21)) && (!OPENSUSE_SLED))
-		crypto_cipher_setkey(tkey->tx_tfm_arc4, rc4key, 16);
-		sg.page = virt_to_page(pos);
-		sg.offset = offset_in_page(pos);
-		sg.length = len + 4;
-		crypto_cipher_encrypt(tkey->tx_tfm_arc4, &sg, &sg, len + 4);
-#else
 		crypto_blkcipher_setkey(tkey->tx_tfm_arc4, rc4key, 16);
-#if(LINUX_VERSION_CODE < KERNEL_VERSION(2,6,24))
-		sg.page = virt_to_page(pos);
-		sg.offset = offset_in_page(pos);
-		sg.length = len + 4;
-#else
 		sg_init_one(&sg, pos, len+4);
-#endif
 		ret= crypto_blkcipher_encrypt(&desc, &sg, &sg, len + 4);
-#endif
 
 	}
 
@@ -483,11 +394,7 @@ printk("%x\n", ((u32*)tkey->key)[7]);
 	}
 
 	if (!tcb_desc->bHwSec)
-#if((LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21)) && (!OPENSUSE_SLED))
-		return 0;
-	#else
 		return ret;
-	#endif
 	else
         	return 0;
 
@@ -502,9 +409,7 @@ static int ieee80211_tkip_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	u16 iv16;
 	struct ieee80211_hdr_4addr *hdr;
 	cb_desc *tcb_desc = (cb_desc *)(skb->cb + MAX_DEV_ADDR_SIZE);
-	#if((LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,21)) || (OPENSUSE_SLED))
 	struct blkcipher_desc desc = {.tfm = tkey->rx_tfm_arc4};
-	#endif
 	u8 rc4key[16];
 	u8 icv[4];
 	u32 crc;
@@ -563,21 +468,8 @@ static int ieee80211_tkip_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 
 		plen = skb->len - hdr_len - 12;
 
-#if((LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21)) && (!OPENSUSE_SLED))
-		crypto_cipher_setkey(tkey->rx_tfm_arc4, rc4key, 16);
-		sg.page = virt_to_page(pos);
-		sg.offset = offset_in_page(pos);
-		sg.length = plen + 4;
-		crypto_cipher_decrypt(tkey->rx_tfm_arc4, &sg, &sg, plen + 4);
-#else
 		crypto_blkcipher_setkey(tkey->rx_tfm_arc4, rc4key, 16);
-#if(LINUX_VERSION_CODE < KERNEL_VERSION(2,6,24))
-		sg.page = virt_to_page(pos);
-		sg.offset = offset_in_page(pos);
-		sg.length = plen + 4;
-#else
 		sg_init_one(&sg, pos, plen+4);
-#endif
 		if (crypto_blkcipher_decrypt(&desc, &sg, &sg, plen + 4)) {
 			if (net_ratelimit()) {
 				printk(KERN_DEBUG ": TKIP: failed to decrypt "
@@ -586,13 +478,8 @@ static int ieee80211_tkip_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 			}
 			return -7;
 		}
-#endif
 
-	#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0))
 		crc = ~crc32_le(~0, pos, plen);
-	#else
-		crc = ~ether_crc_le(plen, pos);
-	#endif
 		icv[0] = crc;
 		icv[1] = crc >> 8;
 		icv[2] = crc >> 16;
@@ -641,47 +528,6 @@ if( ((u16*)skb->data)[0] & 0x4000){
 }
 
 
-#if((LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21)) && (!OPENSUSE_SLED))
-static int michael_mic(struct crypto_tfm * tfm_michael, u8 *key, u8 *hdr,
-		       u8 *data, size_t data_len, u8 *mic)
-{
-	struct scatterlist sg[2];
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20)
-        struct hash_desc desc;
-        int ret = 0;
-#endif
-
-	if (tfm_michael == NULL){
-		printk(KERN_WARNING "michael_mic: tfm_michael == NULL\n");
-		return -1;
-	}
-	sg[0].page = virt_to_page(hdr);
-	sg[0].offset = offset_in_page(hdr);
-	sg[0].length = 16;
-
-	sg[1].page = virt_to_page(data);
-	sg[1].offset = offset_in_page(data);
-	sg[1].length = data_len;
-
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
-	crypto_digest_init(tfm_michael);
-        crypto_digest_setkey(tfm_michael, key, 8);
-        crypto_digest_update(tfm_michael, sg, 2);
-        crypto_digest_final(tfm_michael, mic);
-        return 0;
-#else
-if (crypto_hash_setkey(tkey->tfm_michael, key, 8))
-                return -1;
-
-//      return 0;
-              desc.tfm = tkey->tfm_michael;
-              desc.flags = 0;
-              ret = crypto_hash_digest(&desc, sg, data_len + 16, mic);
-              return ret;
-#endif
-}
-#else
 static int michael_mic(struct crypto_hash *tfm_michael, u8 * key, u8 * hdr,
                        u8 * data, size_t data_len, u8 * mic)
 {
@@ -692,19 +538,9 @@ static int michael_mic(struct crypto_hash *tfm_michael, u8 * key, u8 * hdr,
                 printk(KERN_WARNING "michael_mic: tfm_michael == NULL\n");
                 return -1;
         }
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,24)
-        sg[0].page = virt_to_page(hdr);
-        sg[0].offset = offset_in_page(hdr);
-        sg[0].length = 16;
-
-        sg[1].page = virt_to_page(data);
-        sg[1].offset = offset_in_page(data);
-        sg[1].length = data_len;
-#else
         sg_init_table(sg, 2);
         sg_set_buf(&sg[0], hdr, 16);
         sg_set_buf(&sg[1], data, data_len);
-#endif
 
         if (crypto_hash_setkey(tfm_michael, key, 8))
                 return -1;
@@ -713,7 +549,6 @@ static int michael_mic(struct crypto_hash *tfm_michael, u8 * key, u8 * hdr,
         desc.flags = 0;
         return crypto_hash_digest(&desc, sg, data_len + 16, mic);
 }
-#endif
 
 
 
@@ -772,13 +607,8 @@ static int ieee80211_michael_mic_add(struct sk_buff *skb, int hdr_len, void *pri
 	}
 	// }
 	pos = skb_put(skb, 8);
-#if((LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21)) && (!OPENSUSE_SLED))
-	if (michael_mic(tkey->tx_tfm_michael, &tkey->key[16], tkey->tx_hdr,
-				skb->data + hdr_len, skb->len - 8 - hdr_len, pos))
-#else
 	if (michael_mic(tkey->tx_tfm_michael, &tkey->key[16], tkey->tx_hdr,
 				skb->data + hdr_len, skb->len - 8 - hdr_len, pos))
-#endif
 		return -1;
 
 	return 0;
@@ -850,13 +680,8 @@ static int ieee80211_michael_mic_verify(struct sk_buff *skb, int keyidx,
 	}
 	// }
 
-#if((LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21)) && (!OPENSUSE_SLED))
-	if (michael_mic(tkey->rx_tfm_michael, &tkey->key[24], tkey->rx_hdr,
-				skb->data + hdr_len, skb->len - 8 - hdr_len, mic))
-#else
 	if (michael_mic(tkey->rx_tfm_michael, &tkey->key[24], tkey->rx_hdr,
 				skb->data + hdr_len, skb->len - 8 - hdr_len, mic))
-#endif
             	return -1;
 	if (memcmp(mic, skb->data + skb->len - 8, 8) != 0) {
 		struct ieee80211_hdr_4addr *hdr;
@@ -886,32 +711,18 @@ static int ieee80211_tkip_set_key(void *key, int len, u8 *seq, void *priv)
 {
 	struct ieee80211_tkip_data *tkey = priv;
 	int keyidx;
-#if((LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21)) && (!OPENSUSE_SLED))
-	struct crypto_tfm *tfm = tkey->tx_tfm_michael;
-	struct crypto_tfm *tfm2 = tkey->tx_tfm_arc4;
-	struct crypto_tfm *tfm3 = tkey->rx_tfm_michael;
-	struct crypto_tfm *tfm4 = tkey->rx_tfm_arc4;
-#else
 	struct crypto_hash *tfm = tkey->tx_tfm_michael;
 	struct crypto_blkcipher *tfm2 = tkey->tx_tfm_arc4;
 	struct crypto_hash *tfm3 = tkey->rx_tfm_michael;
 	struct crypto_blkcipher *tfm4 = tkey->rx_tfm_arc4;
-#endif
 
 	keyidx = tkey->key_idx;
 	memset(tkey, 0, sizeof(*tkey));
 	tkey->key_idx = keyidx;
-#if((LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21)) && (!OPENSUSE_SLED))
 	tkey->tx_tfm_michael = tfm;
 	tkey->tx_tfm_arc4 = tfm2;
 	tkey->rx_tfm_michael = tfm3;
 	tkey->rx_tfm_arc4 = tfm4;
-#else
-	tkey->tx_tfm_michael = tfm;
-	tkey->tx_tfm_arc4 = tfm2;
-	tkey->rx_tfm_michael = tfm3;
-	tkey->rx_tfm_arc4 = tfm4;
-#endif
 
 	if (len == TKIP_KEY_LEN) {
 		memcpy(tkey->key, key, TKIP_KEY_LEN);
@@ -1021,11 +832,4 @@ void ieee80211_tkip_null(void)
 //    printk("============>%s()\n", __FUNCTION__);
         return;
 }
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0))
-//EXPORT_SYMBOL(ieee80211_tkip_null);
-#else
-EXPORT_SYMBOL_NOVERS(ieee80211_tkip_null);
-#endif
 
-//module_init(ieee80211_crypto_tkip_init);
-//module_exit(ieee80211_crypto_tkip_exit);
diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_wep.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_wep.c
index c4bbc8d..5dc9764 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_wep.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_wep.c
@@ -21,30 +21,11 @@
 #include "ieee80211.h"
 
 
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0))
-#include "rtl_crypto.h"
-#else
 #include <linux/crypto.h>
-#endif
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
-    #include <asm/scatterlist.h>
-#else
-    #include <linux/scatterlist.h>
-#endif
-//#include <asm/scatterlist.h>
+#include <linux/scatterlist.h>
 #include <linux/crc32.h>
-//
-/*
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0))
-#include "rtl_crypto.h"
-#else
-#include <linux/crypto.h>
-#endif
 
-#include <asm/scatterlist.h>
-#include <linux/crc32.h>
-*/
 MODULE_AUTHOR("Jouni Malinen");
 MODULE_DESCRIPTION("Host AP crypt: WEP");
 MODULE_LICENSE("GPL");
@@ -58,12 +39,8 @@ struct prism2_wep_data {
 	u8 key[WEP_KEY_LEN + 1];
 	u8 key_len;
 	u8 key_idx;
-#if((LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21)) && (!OPENSUSE_SLED))
-	struct crypto_tfm *tfm;
-	#else
         struct crypto_blkcipher *tx_tfm;
         struct crypto_blkcipher *rx_tfm;
-        #endif
 };
 
 
@@ -76,14 +53,6 @@ static void * prism2_wep_init(int keyidx)
 		goto fail;
 	priv->key_idx = keyidx;
 
-#if((LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21)) && (!OPENSUSE_SLED))
-	priv->tfm = crypto_alloc_tfm("arc4", 0);
-	if (priv->tfm == NULL) {
-		printk(KERN_DEBUG "ieee80211_crypt_wep: could not allocate "
-		       "crypto API arc4\n");
-		goto fail;
-	}
-	#else
 	priv->tx_tfm = crypto_alloc_blkcipher("ecb(arc4)", 0, CRYPTO_ALG_ASYNC);
         if (IS_ERR(priv->tx_tfm)) {
                 printk(KERN_DEBUG "ieee80211_crypt_wep: could not allocate "
@@ -98,7 +67,6 @@ static void * prism2_wep_init(int keyidx)
                 priv->rx_tfm = NULL;
                 goto fail;
         }
-        #endif
 
 	/* start WEP IV from a random value */
 	get_random_bytes(&priv->iv, 4);
@@ -106,13 +74,6 @@ static void * prism2_wep_init(int keyidx)
 	return priv;
 
 fail:
-#if((LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21)) && (!OPENSUSE_SLED))
-	if (priv) {
-		if (priv->tfm)
-			crypto_free_tfm(priv->tfm);
-		kfree(priv);
-	}
-	#else
 	if (priv) {
                 if (priv->tx_tfm)
                         crypto_free_blkcipher(priv->tx_tfm);
@@ -120,7 +81,6 @@ fail:
                         crypto_free_blkcipher(priv->rx_tfm);
                 kfree(priv);
         }
-        #endif
 	return NULL;
 }
 
@@ -128,17 +88,12 @@ fail:
 static void prism2_wep_deinit(void *priv)
 {
 	struct prism2_wep_data *_priv = priv;
-#if((LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21)) && (!OPENSUSE_SLED))
-	if (_priv && _priv->tfm)
-		crypto_free_tfm(_priv->tfm);
-	#else
 	if (_priv) {
                 if (_priv->tx_tfm)
                         crypto_free_blkcipher(_priv->tx_tfm);
                 if (_priv->rx_tfm)
                         crypto_free_blkcipher(_priv->rx_tfm);
         }
-        #endif
 	kfree(priv);
 }
 
@@ -155,9 +110,7 @@ static int prism2_wep_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	u8 key[WEP_KEY_LEN + 3];
 	u8 *pos;
 	cb_desc *tcb_desc = (cb_desc *)(skb->cb + MAX_DEV_ADDR_SIZE);
-	#if((LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,21)) || (OPENSUSE_SLED))
 	struct blkcipher_desc desc = {.tfm = wep->tx_tfm};
-	#endif
 	u32 crc;
 	u8 *icv;
 	struct scatterlist sg;
@@ -196,35 +149,16 @@ static int prism2_wep_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	{
 
 		/* Append little-endian CRC32 and encrypt it to produce ICV */
-	#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0))
 		crc = ~crc32_le(~0, pos, len);
-	#else
-		crc = ~ether_crc_le(len, pos);
-	#endif
 		icv = skb_put(skb, 4);
 		icv[0] = crc;
 		icv[1] = crc >> 8;
 		icv[2] = crc >> 16;
 		icv[3] = crc >> 24;
 
-#if((LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21)) && (!OPENSUSE_SLED))
-		crypto_cipher_setkey(wep->tfm, key, klen);
-		sg.page = virt_to_page(pos);
-		sg.offset = offset_in_page(pos);
-		sg.length = len + 4;
-		crypto_cipher_encrypt(wep->tfm, &sg, &sg, len + 4);
-		return 0;
-	#else
 		crypto_blkcipher_setkey(wep->tx_tfm, key, klen);
-	#if(LINUX_VERSION_CODE < KERNEL_VERSION(2,6,24))
-		sg.page = virt_to_page(pos);
-		sg.offset = offset_in_page(pos);
-		sg.length = len + 4;
-	#else
 		sg_init_one(&sg, pos, len+4);
-	#endif
 		return crypto_blkcipher_encrypt(&desc, &sg, &sg, len + 4);
-	#endif
 	}
 
 	return 0;
@@ -245,9 +179,7 @@ static int prism2_wep_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 	u8 key[WEP_KEY_LEN + 3];
 	u8 keyidx, *pos;
 	cb_desc *tcb_desc = (cb_desc *)(skb->cb + MAX_DEV_ADDR_SIZE);
-	#if((LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,21)) || (OPENSUSE_SLED))
 	struct blkcipher_desc desc = {.tfm = wep->rx_tfm};
-	#endif
 	u32 crc;
 	u8 icv[4];
 	struct scatterlist sg;
@@ -272,29 +204,11 @@ static int prism2_wep_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
 
 	if (!tcb_desc->bHwSec)
 	{
-#if((LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21)) && (!OPENSUSE_SLED))
-		crypto_cipher_setkey(wep->tfm, key, klen);
-		sg.page = virt_to_page(pos);
-		sg.offset = offset_in_page(pos);
-		sg.length = plen + 4;
-		crypto_cipher_decrypt(wep->tfm, &sg, &sg, plen + 4);
-	#else
 		crypto_blkcipher_setkey(wep->rx_tfm, key, klen);
-	#if(LINUX_VERSION_CODE < KERNEL_VERSION(2,6,24))
-		sg.page = virt_to_page(pos);
-		sg.offset = offset_in_page(pos);
-		sg.length = plen + 4;
-	#else
 		sg_init_one(&sg, pos, plen+4);
-	#endif
 		if (crypto_blkcipher_decrypt(&desc, &sg, &sg, plen + 4))
 			return -7;
-	#endif
-	#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0))
 		crc = ~crc32_le(~0, pos, plen);
-	#else
-		crc = ~ether_crc_le(plen, pos);
-	#endif
 		icv[0] = crc;
 		icv[1] = crc >> 8;
 		icv[2] = crc >> 16;
@@ -379,14 +293,6 @@ void __exit ieee80211_crypto_wep_exit(void)
 
 void ieee80211_wep_null(void)
 {
-//	printk("============>%s()\n", __FUNCTION__);
         return;
 }
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0))
-//EXPORT_SYMBOL(ieee80211_wep_null);
-#else
-EXPORT_SYMBOL_NOVERS(ieee80211_wep_null);
-#endif
 
-//module_init(ieee80211_crypto_wep_init);
-//module_exit(ieee80211_crypto_wep_exit);
diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_module.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_module.c
index 614a8b6..7edf5c8 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_module.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_module.c
@@ -31,7 +31,6 @@
 *******************************************************************************/
 
 #include <linux/compiler.h>
-//#include <linux/config.h>
 #include <linux/errno.h>
 #include <linux/if_arp.h>
 #include <linux/in6.h>
@@ -110,14 +109,7 @@ struct net_device *alloc_ieee80211(int sizeof_priv)
 		goto failed;
 	}
 
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0))
 	ieee = netdev_priv(dev);
-#else
-	ieee = (struct ieee80211_device *)dev->priv;
-#endif
-#if 0
-	dev->hard_start_xmit = ieee80211_rtl_xmit;
-#endif
 
 	memset(ieee, 0, sizeof(struct ieee80211_device)+sizeof_priv);
 	ieee->dev = dev;
@@ -166,12 +158,7 @@ struct net_device *alloc_ieee80211(int sizeof_priv)
 
 	ieee80211_softmac_init(ieee);
 
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,13))
 	ieee->pHTInfo = kzalloc(sizeof(RT_HIGH_THROUGHPUT), GFP_KERNEL);
-#else
-	ieee->pHTInfo = (RT_HIGH_THROUGHPUT*)kmalloc(sizeof(RT_HIGH_THROUGHPUT), GFP_KERNEL);
-	memset(ieee->pHTInfo,0,sizeof(RT_HIGH_THROUGHPUT));
-#endif
 	if (ieee->pHTInfo == NULL)
 	{
 		IEEE80211_DEBUG(IEEE80211_DL_ERR, "can't alloc memory for HTInfo\n");
@@ -180,13 +167,6 @@ struct net_device *alloc_ieee80211(int sizeof_priv)
 	HTUpdateDefaultSetting(ieee);
 	HTInitializeHTInfo(ieee); //may move to other place.
 	TSInitialize(ieee);
-#if 0
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
- 	INIT_WORK(&ieee->ht_onAssRsp, (void(*)(void*)) HTOnAssocRsp_wq);
-#else
-	INIT_WORK(&ieee->ht_onAssRsp, (void(*)(void*)) HTOnAssocRsp_wq, ieee);
-#endif
-#endif
 	for (i = 0; i < IEEE_IBSS_MAC_HASH_SIZE; i++)
 		INIT_LIST_HEAD(&ieee->ibss_mac_hash[i]);
 
@@ -205,32 +185,20 @@ struct net_device *alloc_ieee80211(int sizeof_priv)
 
  failed:
 	if (dev)
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0))
 		free_netdev(dev);
-#else
-		kfree(dev);
-#endif
 	return NULL;
 }
 
 
 void free_ieee80211(struct net_device *dev)
 {
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0))
 	struct ieee80211_device *ieee = netdev_priv(dev);
-#else
-	struct ieee80211_device *ieee = (struct ieee80211_device *)dev->priv;
-#endif
 	int i;
-	//struct list_head *p, *q;
-//	del_timer_sync(&ieee->SwBwTimer);
-#if 1
 	if (ieee->pHTInfo != NULL)
 	{
 		kfree(ieee->pHTInfo);
 		ieee->pHTInfo = NULL;
 	}
-#endif
 	RemoveAllTS(ieee);
 	ieee80211_softmac_free(ieee);
 	del_timer_sync(&ieee->crypt_deinit_timer);
@@ -247,20 +215,7 @@ void free_ieee80211(struct net_device *dev)
 	}
 
 	ieee80211_networks_free(ieee);
-#if 0
-	for (i = 0; i < IEEE_IBSS_MAC_HASH_SIZE; i++) {
-		list_for_each_safe(p, q, &ieee->ibss_mac_hash[i]) {
-			kfree(list_entry(p, struct ieee_ibss_seq, list));
-			list_del(p);
-		}
-	}
-
-#endif
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0))
 	free_netdev(dev);
-#else
-	kfree(dev);
-#endif
 }
 
 #ifdef CONFIG_IEEE80211_DEBUG
@@ -358,11 +313,7 @@ int __init ieee80211_rtl_init(void)
 	}
 
 	ieee80211_debug_level = debug;
-#if(LINUX_VERSION_CODE < KERNEL_VERSION(2,6,24))
-	ieee80211_proc = create_proc_entry(DRV_NAME, S_IFDIR, proc_net);
-#else
 	ieee80211_proc = create_proc_entry(DRV_NAME, S_IFDIR, init_net.proc_net);
-#endif
 	if (ieee80211_proc == NULL) {
 		IEEE80211_ERROR("Unable to create " DRV_NAME
 				" proc directory\n");
@@ -371,11 +322,7 @@ int __init ieee80211_rtl_init(void)
 	e = create_proc_entry("debug_level", S_IFREG | S_IRUGO | S_IWUSR,
 			      ieee80211_proc);
 	if (!e) {
-#if(LINUX_VERSION_CODE < KERNEL_VERSION(2,6,24))
-		remove_proc_entry(DRV_NAME, proc_net);
-#else
 		remove_proc_entry(DRV_NAME, init_net.proc_net);
-#endif
 		ieee80211_proc = NULL;
 		return -EIO;
 	}
@@ -390,11 +337,7 @@ void __exit ieee80211_rtl_exit(void)
 {
 	if (ieee80211_proc) {
 		remove_proc_entry("debug_level", ieee80211_proc);
-#if(LINUX_VERSION_CODE < KERNEL_VERSION(2,6,24))
-		remove_proc_entry(DRV_NAME, proc_net);
-#else
 		remove_proc_entry(DRV_NAME, init_net.proc_net);
-#endif
 		ieee80211_proc = NULL;
 	}
 	ieee80211_crypto_wep_exit();
@@ -403,21 +346,10 @@ void __exit ieee80211_rtl_exit(void)
 	ieee80211_crypto_deinit();
 }
 
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0))
 #include <linux/moduleparam.h>
 module_param(debug, int, 0444);
 MODULE_PARM_DESC(debug, "debug output mask");
 
 
-//module_exit(ieee80211_rtl_exit);
-//module_init(ieee80211_rtl_init);
-#endif
 #endif
 
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0))
-//EXPORT_SYMBOL(alloc_ieee80211);
-//EXPORT_SYMBOL(free_ieee80211);
-#else
-EXPORT_SYMBOL_NOVERS(alloc_ieee80211);
-EXPORT_SYMBOL_NOVERS(free_ieee80211);
-#endif
diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_rx.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_rx.c
index da10067..7540a9f 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_rx.c
@@ -55,11 +55,7 @@ static inline void ieee80211_monitor_rx(struct ieee80211_device *ieee,
 	u16 fc = le16_to_cpu(hdr->frame_ctl);
 
 	skb->dev = ieee->dev;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,22)
         skb_reset_mac_header(skb);
-#else
-        skb->mac.raw = skb->data;
-#endif
 
 	skb_pull(skb, ieee80211_get_hdrlen(fc));
 	skb->pkt_type = PACKET_OTHERHOST;
@@ -2881,10 +2877,4 @@ void ieee80211_rx_mgt(struct ieee80211_device *ieee,
 	}
 }
 
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0))
-//EXPORT_SYMBOL(ieee80211_rx_mgt);
-//EXPORT_SYMBOL(ieee80211_rx);
-#else
-EXPORT_SYMBOL_NOVERS(ieee80211_rx_mgt);
-EXPORT_SYMBOL_NOVERS(ieee80211_rx);
-#endif
+
diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c
index 46b6e8c..a60b001 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c
@@ -510,34 +510,11 @@ out:
 }
 }
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-/* called both by wq with ieee->lock held */
-void ieee80211_softmac_scan(struct ieee80211_device *ieee)
-{
-#if 0
-	short watchdog = 0;
-	do{
-		ieee->current_network.channel =
-			(ieee->current_network.channel + 1) % MAX_CHANNEL_NUMBER;
-		if (watchdog++ > MAX_CHANNEL_NUMBER)
-				return; /* no good chans */
-
-	}while(!ieee->channel_map[ieee->current_network.channel]);
-#endif
 
-	schedule_task(&ieee->softmac_scan_wq);
-}
-#endif
-
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
 void ieee80211_softmac_scan_wq(struct work_struct *work)
 {
         struct delayed_work *dwork = container_of(work, struct delayed_work, work);
         struct ieee80211_device *ieee = container_of(dwork, struct ieee80211_device, softmac_scan_wq);
-#else
-void ieee80211_softmac_scan_wq(struct ieee80211_device *ieee)
-{
-#endif
 	static short watchdog = 0;
 	u8 last_channel = ieee->current_network.channel;
 #ifdef ENABLE_DOT11D
@@ -575,13 +552,7 @@ void ieee80211_softmac_scan_wq(struct ieee80211_device *ieee)
 	ieee80211_send_probe_requests(ieee);
 
 
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
 	queue_delayed_work(ieee->wq, &ieee->softmac_scan_wq, IEEE80211_SOFTMAC_SCAN_TIME);
-#else
-	//ieee->scan_timer.expires = jiffies + MSECS(IEEE80211_SOFTMAC_SCAN_TIME);
-	if (ieee->scanning == 1)
-		mod_timer(&ieee->scan_timer,(jiffies + MSECS(IEEE80211_SOFTMAC_SCAN_TIME)));
-#endif
 
 	up(&ieee->scan_sem);
 	return;
@@ -597,19 +568,6 @@ out:
 	up(&ieee->scan_sem);
 }
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-void ieee80211_softmac_scan_cb(unsigned long _dev)
-{
-	unsigned long flags;
-	struct ieee80211_device *ieee = (struct ieee80211_device *)_dev;
-
-	spin_lock_irqsave(&ieee->lock, flags);
-	ieee80211_softmac_scan(ieee);
-	spin_unlock_irqrestore(&ieee->lock, flags);
-}
-#endif
-
-
 void ieee80211_beacons_start(struct ieee80211_device *ieee)
 {
 	unsigned long flags;
@@ -665,11 +623,7 @@ void ieee80211_softmac_stop_scan(struct ieee80211_device *ieee)
 	if (ieee->scanning == 1){
 		ieee->scanning = 0;
 
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
 		cancel_delayed_work(&ieee->softmac_scan_wq);
-#else
-		del_timer_sync(&ieee->scan_timer);
-#endif
 	}
 
 //	spin_unlock_irqrestore(&ieee->lock, flags);
@@ -704,16 +658,10 @@ void ieee80211_rtl_start_scan(struct ieee80211_device *ieee)
 	if (ieee->softmac_features & IEEE_SOFTMAC_SCAN){
 		if (ieee->scanning == 0){
 			ieee->scanning = 1;
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20)
 			queue_delayed_work(ieee->wq, &ieee->softmac_scan_wq, 0);
-#else
 
 			queue_work(ieee->wq, &ieee->softmac_scan_wq);
-#endif
-#else
 			ieee80211_softmac_scan(ieee);
-#endif
 		}
 	}else
 		ieee->start_scan(ieee->dev);
@@ -1428,13 +1376,8 @@ void ieee80211_associate_abort(struct ieee80211_device *ieee)
 
 	ieee->state = IEEE80211_ASSOCIATING_RETRY;
 
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
 	queue_delayed_work(ieee->wq, &ieee->associate_retry_wq, \
                            IEEE80211_SOFTMAC_ASSOC_RETRY_TIME);
-#else
-	schedule_task(&ieee->associate_retry_wq);
-#endif
-
 	spin_unlock_irqrestore(&ieee->lock, flags);
 }
 
@@ -1527,14 +1470,9 @@ void ieee80211_associate_step2(struct ieee80211_device *ieee)
 		//dev_kfree_skb_any(skb);//edit by thomas
 	}
 }
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
 void ieee80211_associate_complete_wq(struct work_struct *work)
 {
         struct ieee80211_device *ieee = container_of(work, struct ieee80211_device, associate_complete_wq);
-#else
-void ieee80211_associate_complete_wq(struct ieee80211_device *ieee)
-{
-#endif
 	printk(KERN_INFO "Associated successfully\n");
 	ieee->is_roaming = false;
 	if(ieee80211_is_54g(ieee->current_network) &&
@@ -1606,21 +1544,12 @@ void ieee80211_associate_complete(struct ieee80211_device *ieee)
 	}
 #endif
 	//ieee->UpdateHalRATRTableHandler(dev, ieee->dot11HTOperationalRateSet);
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
 	queue_work(ieee->wq, &ieee->associate_complete_wq);
-#else
-	schedule_task(&ieee->associate_complete_wq);
-#endif
 }
 
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
 void ieee80211_associate_procedure_wq(struct work_struct *work)
 {
         struct ieee80211_device *ieee = container_of(work, struct ieee80211_device, associate_procedure_wq);
-#else
-void ieee80211_associate_procedure_wq(struct ieee80211_device *ieee)
-{
-#endif
 	ieee->sync_scan_hurryup = 1;
 #ifdef ENABLE_IPS
 	if(ieee->ieee80211_ips_leave != NULL)
@@ -1734,11 +1663,7 @@ inline void ieee80211_softmac_new_net(struct ieee80211_device *ieee, struct ieee
 					}
 
 					ieee->state = IEEE80211_ASSOCIATING;
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
 					queue_work(ieee->wq, &ieee->associate_procedure_wq);
-#else
-					schedule_task(&ieee->associate_procedure_wq);
-#endif
 				}else{
 					if(ieee80211_is_54g(ieee->current_network) &&
 						(ieee->modulation & IEEE80211_OFDM_MODULATION)){
@@ -2332,11 +2257,7 @@ ieee80211_rx_frame_softmac(struct ieee80211_device *ieee, struct sk_buff *skb,
 						"Association response status code 0x%x\n",
 						errcode);
 					if(ieee->AsocRetryCount < RT_ASOC_RETRY_LIMIT) {
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
 						queue_work(ieee->wq, &ieee->associate_procedure_wq);
-#else
-						schedule_task(&ieee->associate_procedure_wq);
-#endif
 					} else {
 						ieee80211_associate_abort(ieee);
 					}
@@ -2446,11 +2367,7 @@ ieee80211_rx_frame_softmac(struct ieee80211_device *ieee, struct sk_buff *skb,
 			//	notify_wx_assoc_event(ieee);
 				//HTSetConnectBwMode(ieee, HT_CHANNEL_WIDTH_20, HT_EXTCHNL_OFFSET_NO_EXT);
 				RemovePeerTS(ieee, header->addr2);
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
 				queue_work(ieee->wq, &ieee->associate_procedure_wq);
-#else
-				schedule_task(&ieee->associate_procedure_wq);
-#endif
 			}
 			break;
 		case IEEE80211_STYPE_MANAGE_ACT:
@@ -2687,16 +2604,11 @@ void ieee80211_start_monitor_mode(struct ieee80211_device *ieee)
 		netif_carrier_on(ieee->dev);
 	}
 }
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
 void ieee80211_start_ibss_wq(struct work_struct *work)
 {
 
         struct delayed_work *dwork = container_of(work, struct delayed_work, work);
         struct ieee80211_device *ieee = container_of(dwork, struct ieee80211_device, start_ibss_wq);
-#else
-void ieee80211_start_ibss_wq(struct ieee80211_device *ieee)
-{
-#endif
 	/* iwconfig mode ad-hoc will schedule this and return
 	 * on the other hand this will block further iwconfig SET
 	 * operations because of the wx_sem hold.
@@ -2807,11 +2719,7 @@ void ieee80211_start_ibss_wq(struct ieee80211_device *ieee)
 
 inline void ieee80211_start_ibss(struct ieee80211_device *ieee)
 {
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
 	queue_delayed_work(ieee->wq, &ieee->start_ibss_wq, 150);
-#else
-	schedule_task(&ieee->start_ibss_wq);
-#endif
 }
 
 /* this is called only in user context, with wx_sem held */
@@ -2880,15 +2788,10 @@ void ieee80211_disassociate(struct ieee80211_device *ieee)
 	notify_wx_assoc_event(ieee);
 
 }
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
 void ieee80211_associate_retry_wq(struct work_struct *work)
 {
         struct delayed_work *dwork = container_of(work, struct delayed_work, work);
         struct ieee80211_device *ieee = container_of(dwork, struct ieee80211_device, associate_retry_wq);
-#else
-void ieee80211_associate_retry_wq(struct ieee80211_device *ieee)
-{
-#endif
 	unsigned long flags;
 
 	down(&ieee->wx_sem);
@@ -2990,10 +2893,8 @@ void ieee80211_stop_protocol(struct ieee80211_device *ieee, u8 shutdown)
 
 	ieee80211_stop_send_beacons(ieee);
 	del_timer_sync(&ieee->associate_timer);
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
 	cancel_delayed_work(&ieee->associate_retry_wq);
 	cancel_delayed_work(&ieee->start_ibss_wq);
-#endif
 	ieee80211_stop_scan(ieee);
 
 	ieee80211_disassociate(ieee);
@@ -3114,11 +3015,6 @@ void ieee80211_softmac_init(struct ieee80211_device *ieee)
 	ieee->sta_edca_param[3] = 0x002F3262;
 	ieee->aggregation = true;
 	ieee->enable_rx_imm_BA = 1;
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-	init_timer(&ieee->scan_timer);
-	ieee->scan_timer.data = (unsigned long)ieee;
-	ieee->scan_timer.function = ieee80211_softmac_scan_cb;
-#endif
 	ieee->tx_pending.txb = NULL;
 
 	init_timer(&ieee->associate_timer);
@@ -3129,16 +3025,12 @@ void ieee80211_softmac_init(struct ieee80211_device *ieee)
 	ieee->beacon_timer.data = (unsigned long) ieee;
 	ieee->beacon_timer.function = ieee80211_send_beacon_cb;
 
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
 #ifdef PF_SYNCTHREAD
 	ieee->wq = create_workqueue(DRV_NAME,0);
 #else
 	ieee->wq = create_workqueue(DRV_NAME);
 #endif
-#endif
 
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20)
         INIT_DELAYED_WORK(&ieee->start_ibss_wq,ieee80211_start_ibss_wq);
         INIT_WORK(&ieee->associate_complete_wq, ieee80211_associate_complete_wq);
         INIT_WORK(&ieee->associate_procedure_wq, ieee80211_associate_procedure_wq);
@@ -3146,23 +3038,6 @@ void ieee80211_softmac_init(struct ieee80211_device *ieee)
         INIT_DELAYED_WORK(&ieee->associate_retry_wq, ieee80211_associate_retry_wq);
         INIT_WORK(&ieee->wx_sync_scan_wq,ieee80211_wx_sync_scan_wq);
 
-#else
-	INIT_WORK(&ieee->start_ibss_wq,(void(*)(void*)) ieee80211_start_ibss_wq,ieee);
-	INIT_WORK(&ieee->associate_retry_wq,(void(*)(void*)) ieee80211_associate_retry_wq,ieee);
-	INIT_WORK(&ieee->associate_complete_wq,(void(*)(void*)) ieee80211_associate_complete_wq,ieee);
-	INIT_WORK(&ieee->associate_procedure_wq,(void(*)(void*)) ieee80211_associate_procedure_wq,ieee);
-	INIT_WORK(&ieee->softmac_scan_wq,(void(*)(void*)) ieee80211_softmac_scan_wq,ieee);
-	INIT_WORK(&ieee->wx_sync_scan_wq,(void(*)(void*)) ieee80211_wx_sync_scan_wq,ieee);
-#endif
-
-#else
-	tq_init(&ieee->start_ibss_wq,(void(*)(void*)) ieee80211_start_ibss_wq,ieee);
-	tq_init(&ieee->associate_retry_wq,(void(*)(void*)) ieee80211_associate_retry_wq,ieee);
-	tq_init(&ieee->associate_complete_wq,(void(*)(void*)) ieee80211_associate_complete_wq,ieee);
-	tq_init(&ieee->associate_procedure_wq,(void(*)(void*)) ieee80211_associate_procedure_wq,ieee);
-	tq_init(&ieee->softmac_scan_wq,(void(*)(void*)) ieee80211_softmac_scan_wq,ieee);
-	tq_init(&ieee->wx_sync_scan_wq,(void(*)(void*)) ieee80211_wx_sync_scan_wq,ieee);
-#endif
 	sema_init(&ieee->wx_sem, 1);
 	sema_init(&ieee->scan_sem, 1);
 #ifdef ENABLE_IPS
@@ -3189,10 +3064,8 @@ void ieee80211_softmac_free(struct ieee80211_device *ieee)
 #endif
 	del_timer_sync(&ieee->associate_timer);
 
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
 	cancel_delayed_work(&ieee->associate_retry_wq);
 	destroy_workqueue(ieee->wq);
-#endif
 
 	up(&ieee->wx_sem);
 }
@@ -3648,48 +3521,4 @@ void notify_wx_assoc_event(struct ieee80211_device *ieee)
 	wireless_send_event(ieee->dev, SIOCGIWAP, &wrqu, NULL);
 }
 
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0))
-//EXPORT_SYMBOL(ieee80211_get_beacon);
-//EXPORT_SYMBOL(ieee80211_rtl_wake_queue);
-//EXPORT_SYMBOL(ieee80211_rtl_stop_queue);
-//EXPORT_SYMBOL(ieee80211_reset_queue);
-//EXPORT_SYMBOL(ieee80211_softmac_stop_protocol);
-//EXPORT_SYMBOL(ieee80211_softmac_start_protocol);
-//EXPORT_SYMBOL(ieee80211_is_shortslot);
-//EXPORT_SYMBOL(ieee80211_is_54g);
-//EXPORT_SYMBOL(ieee80211_wpa_supplicant_ioctl);
-//EXPORT_SYMBOL(ieee80211_ps_tx_ack);
-//EXPORT_SYMBOL(ieee80211_softmac_xmit);
-//EXPORT_SYMBOL(ieee80211_stop_send_beacons);
-//EXPORT_SYMBOL(notify_wx_assoc_event);
-//EXPORT_SYMBOL(SendDisassociation);
-//EXPORT_SYMBOL(ieee80211_disassociate);
-//EXPORT_SYMBOL(ieee80211_start_send_beacons);
-//EXPORT_SYMBOL(ieee80211_stop_scan);
-//EXPORT_SYMBOL(ieee80211_send_probe_requests);
-//EXPORT_SYMBOL(ieee80211_softmac_scan_syncro);
-//EXPORT_SYMBOL(ieee80211_start_scan_syncro);
-#else
-EXPORT_SYMBOL_NOVERS(ieee80211_get_beacon);
-EXPORT_SYMBOL_NOVERS(ieee80211_rtl_wake_queue);
-EXPORT_SYMBOL_NOVERS(ieee80211_rtl_stop_queue);
-EXPORT_SYMBOL_NOVERS(ieee80211_reset_queue);
-EXPORT_SYMBOL_NOVERS(ieee80211_softmac_stop_protocol);
-EXPORT_SYMBOL_NOVERS(ieee80211_softmac_start_protocol);
-EXPORT_SYMBOL_NOVERS(ieee80211_is_shortslot);
-EXPORT_SYMBOL_NOVERS(ieee80211_is_54g);
-EXPORT_SYMBOL_NOVERS(ieee80211_wpa_supplicant_ioctl);
-EXPORT_SYMBOL_NOVERS(ieee80211_ps_tx_ack);
-EXPORT_SYMBOL_NOVERS(ieee80211_softmac_xmit);
-EXPORT_SYMBOL_NOVERS(ieee80211_stop_send_beacons);
-EXPORT_SYMBOL_NOVERS(notify_wx_assoc_event);
-EXPORT_SYMBOL_NOVERS(SendDisassociation);
-EXPORT_SYMBOL_NOVERS(ieee80211_disassociate);
-EXPORT_SYMBOL_NOVERS(ieee80211_start_send_beacons);
-EXPORT_SYMBOL_NOVERS(ieee80211_stop_scan);
-EXPORT_SYMBOL_NOVERS(ieee80211_send_probe_requests);
-EXPORT_SYMBOL_NOVERS(ieee80211_softmac_scan_syncro);
-EXPORT_SYMBOL_NOVERS(ieee80211_start_scan_syncro);
-EXPORT_SYMBOL_NOVERS(ieee80211_sta_ps_send_null_frame);
-EXPORT_SYMBOL_NOVERS(ieee80211_sta_ps_send_pspoll_frame);
-#endif
+
diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac_wx.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac_wx.c
index 1bbd49f..f141828 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac_wx.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac_wx.c
@@ -312,14 +312,9 @@ out:
 	return 0;
 }
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20)
 void ieee80211_wx_sync_scan_wq(struct work_struct *work)
 {
         struct ieee80211_device *ieee = container_of(work, struct ieee80211_device, wx_sync_scan_wq);
-#else
-void ieee80211_wx_sync_scan_wq(struct ieee80211_device *ieee)
-{
-#endif
 	short chan;
 	HT_EXTCHNL_OFFSET chan_offset=0;
 	HT_CHANNEL_WIDTH bandwidth=0;
@@ -408,11 +403,7 @@ int ieee80211_wx_set_scan(struct ieee80211_device *ieee, struct iw_request_info
 	}
 
 	if ( ieee->state == IEEE80211_LINKED){
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
 		queue_work(ieee->wq, &ieee->wx_sync_scan_wq);
-#else
-		schedule_task(&ieee->wx_sync_scan_wq);
-#endif
 		/* intentionally forget to up sem */
 		return 0;
 	}
@@ -459,29 +450,8 @@ int ieee80211_wx_set_essid(struct ieee80211_device *ieee,
 	if (wrqu->essid.flags && wrqu->essid.length) {
 		//first flush current network.ssid
 		len = ((wrqu->essid.length-1) < IW_ESSID_MAX_SIZE) ? (wrqu->essid.length-1) : IW_ESSID_MAX_SIZE;
-#if LINUX_VERSION_CODE <  KERNEL_VERSION(2,6,20)
-		strncpy(ieee->current_network.ssid, extra, len);
-		ieee->current_network.ssid_len = len;
-#if 0
-		{
-			int i;
-			for (i=0; i<len; i++)
-				printk("%c ", extra[i]);
-			printk("\n");
-		}
-#endif
-#else
 		strncpy(ieee->current_network.ssid, extra, len+1);
 		ieee->current_network.ssid_len = len+1;
-#if 0
-		{
-			int i;
-			for (i=0; i<len + 1; i++)
-				printk("%c ", extra[i]);
-			printk("\n");
-		}
-#endif
-#endif
 		ieee->ssid_set = 1;
 	}
 	else{
@@ -659,42 +629,4 @@ exit:
 	return ret;
 
 }
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0))
-//EXPORT_SYMBOL(ieee80211_wx_get_essid);
-//EXPORT_SYMBOL(ieee80211_wx_set_essid);
-//EXPORT_SYMBOL(ieee80211_wx_set_rate);
-//EXPORT_SYMBOL(ieee80211_wx_get_rate);
-//EXPORT_SYMBOL(ieee80211_wx_set_wap);
-//EXPORT_SYMBOL(ieee80211_wx_get_wap);
-//EXPORT_SYMBOL(ieee80211_wx_set_mode);
-//EXPORT_SYMBOL(ieee80211_wx_get_mode);
-//EXPORT_SYMBOL(ieee80211_wx_set_scan);
-//EXPORT_SYMBOL(ieee80211_wx_get_freq);
-//EXPORT_SYMBOL(ieee80211_wx_set_freq);
-//EXPORT_SYMBOL(ieee80211_wx_set_rawtx);
-//EXPORT_SYMBOL(ieee80211_wx_get_name);
-//EXPORT_SYMBOL(ieee80211_wx_set_power);
-//EXPORT_SYMBOL(ieee80211_wx_get_power);
-//EXPORT_SYMBOL(ieee80211_wlan_frequencies);
-//EXPORT_SYMBOL(ieee80211_wx_set_rts);
-//EXPORT_SYMBOL(ieee80211_wx_get_rts);
-#else
-EXPORT_SYMBOL_NOVERS(ieee80211_wx_get_essid);
-EXPORT_SYMBOL_NOVERS(ieee80211_wx_set_essid);
-EXPORT_SYMBOL_NOVERS(ieee80211_wx_set_rate);
-EXPORT_SYMBOL_NOVERS(ieee80211_wx_get_rate);
-EXPORT_SYMBOL_NOVERS(ieee80211_wx_set_wap);
-EXPORT_SYMBOL_NOVERS(ieee80211_wx_get_wap);
-EXPORT_SYMBOL_NOVERS(ieee80211_wx_set_mode);
-EXPORT_SYMBOL_NOVERS(ieee80211_wx_get_mode);
-EXPORT_SYMBOL_NOVERS(ieee80211_wx_set_scan);
-EXPORT_SYMBOL_NOVERS(ieee80211_wx_get_freq);
-EXPORT_SYMBOL_NOVERS(ieee80211_wx_set_freq);
-EXPORT_SYMBOL_NOVERS(ieee80211_wx_set_rawtx);
-EXPORT_SYMBOL_NOVERS(ieee80211_wx_get_name);
-EXPORT_SYMBOL_NOVERS(ieee80211_wx_set_power);
-EXPORT_SYMBOL_NOVERS(ieee80211_wx_get_power);
-EXPORT_SYMBOL_NOVERS(ieee80211_wlan_frequencies);
-EXPORT_SYMBOL_NOVERS(ieee80211_wx_set_rts);
-EXPORT_SYMBOL_NOVERS(ieee80211_wx_get_rts);
-#endif
+
diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_tx.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_tx.c
index a75f366..dd8a221 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_tx.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_tx.c
@@ -286,12 +286,7 @@ ieee80211_classify(struct sk_buff *skb, struct ieee80211_network *network)
 	if (eth->h_proto != htons(ETH_P_IP))
 		return 0;
 
-//	IEEE80211_DEBUG_DATA(IEEE80211_DL_DATA, skb->data, skb->len);
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,22))
 	ip = ip_hdr(skb);
-#else
-	ip = (struct iphdr*)(skb->data + sizeof(struct ether_header));
-#endif
 	switch (ip->tos & 0xfc) {
 		case 0x20:
 			return 2;
@@ -613,11 +608,7 @@ void ieee80211_query_seqnum(struct ieee80211_device*ieee, struct sk_buff* skb, u
 
 int ieee80211_rtl_xmit(struct sk_buff *skb, struct net_device *dev)
 {
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0))
 	struct ieee80211_device *ieee = netdev_priv(dev);
-#else
-	struct ieee80211_device *ieee = (struct ieee80211_device *)dev->priv;
-#endif
 	struct ieee80211_txb *txb = NULL;
 	struct ieee80211_hdr_3addrqos *frag_hdr;
 	int i, bytes_per_frag, nr_frags, bytes_last_frag, frag_size;
diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_wx.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_wx.c
index 4971b1c..31d1748 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_wx.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_wx.c
@@ -54,25 +54,7 @@ struct modes_unit ieee80211_modes[] = {
 	{"N-5G",4},
 };
 
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,4,20)) && (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0))
-static inline char *
-iwe_stream_add_event_rsl(char *     stream,         /* Stream of events */
-                     char *     ends,           /* End of stream */
-                     struct iw_event *iwe,      /* Payload */
-                     int        event_len)      /* Real size of payload */
-{
-        /* Check if it's possible */
-        if((stream + event_len) < ends) {
-                iwe->len = event_len;
-		ndelay(1);   //new
-                memcpy(stream, (char *) iwe, event_len);
-                stream += event_len;
-        }
-        return stream;
-}
-#else
 #define iwe_stream_add_event_rsl iwe_stream_add_event
-#endif
 
 #define MAX_CUSTOM_LEN 64
 static inline char *rtl819x_translate_scan(struct ieee80211_device *ieee,
@@ -93,11 +75,7 @@ static inline char *rtl819x_translate_scan(struct ieee80211_device *ieee,
 	iwe.cmd = SIOCGIWAP;
 	iwe.u.ap_addr.sa_family = ARPHRD_ETHER;
 	memcpy(iwe.u.ap_addr.sa_data, network->bssid, ETH_ALEN);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)
 	start = iwe_stream_add_event_rsl(info, start, stop, &iwe, IW_EV_ADDR_LEN);
-#else
-	start = iwe_stream_add_event_rsl(start, stop, &iwe, IW_EV_ADDR_LEN);
-#endif
 	/* Remaining entries will be displayed in the order we provide them */
 
 	/* Add the ESSID */
@@ -106,18 +84,10 @@ static inline char *rtl819x_translate_scan(struct ieee80211_device *ieee,
 //	if (network->flags & NETWORK_EMPTY_ESSID) {
 	if (network->ssid_len == 0) {
 		iwe.u.data.length = sizeof("<hidden>");
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)
                 start = iwe_stream_add_point(info, start, stop, &iwe, "<hidden>");
-#else
-                start = iwe_stream_add_point(start, stop, &iwe, "<hidden>");
-#endif
         } else {
 		iwe.u.data.length = min(network->ssid_len, (u8)32);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)
                 start = iwe_stream_add_point(info, start, stop, &iwe, network->ssid);
-#else
-                start = iwe_stream_add_point(start, stop, &iwe, network->ssid);
-#endif
         }
 	/* Add the protocol name */
 	iwe.cmd = SIOCGIWNAME;
@@ -129,11 +99,7 @@ static inline char *rtl819x_translate_scan(struct ieee80211_device *ieee,
 	}
 	*pname = '\0';
 	snprintf(iwe.u.name, IFNAMSIZ, "IEEE802.11%s", proto_name);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)
         start = iwe_stream_add_event_rsl(info, start, stop, &iwe, IW_EV_CHAR_LEN);
-#else
-        start = iwe_stream_add_event_rsl(start, stop, &iwe, IW_EV_CHAR_LEN);
-#endif
         /* Add mode */
         iwe.cmd = SIOCGIWMODE;
         if (network->capability &
@@ -142,11 +108,7 @@ static inline char *rtl819x_translate_scan(struct ieee80211_device *ieee,
 			iwe.u.mode = IW_MODE_MASTER;
 		else
 			iwe.u.mode = IW_MODE_ADHOC;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)
                 start = iwe_stream_add_event_rsl(info, start, stop, &iwe, IW_EV_UINT_LEN);
-#else
-                start = iwe_stream_add_event_rsl(start, stop, &iwe, IW_EV_UINT_LEN);
-#endif
         }
 
         /* Add frequency/channel */
@@ -156,11 +118,7 @@ static inline char *rtl819x_translate_scan(struct ieee80211_device *ieee,
 	iwe.u.freq.m = network->channel;
 	iwe.u.freq.e = 0;
 	iwe.u.freq.i = 0;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)
         start = iwe_stream_add_event_rsl(info, start, stop, &iwe, IW_EV_FREQ_LEN);
-#else
-        start = iwe_stream_add_event_rsl(start, stop, &iwe, IW_EV_FREQ_LEN);
-#endif
 	/* Add encryption capability */
 	iwe.cmd = SIOCGIWENCODE;
 	if (network->capability & WLAN_CAPABILITY_PRIVACY)
@@ -168,11 +126,7 @@ static inline char *rtl819x_translate_scan(struct ieee80211_device *ieee,
 	else
 		iwe.u.data.flags = IW_ENCODE_DISABLED;
 	iwe.u.data.length = 0;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)
         start = iwe_stream_add_point(info, start, stop, &iwe, network->ssid);
-#else
-        start = iwe_stream_add_point(start, stop, &iwe, network->ssid);
-#endif
 	/* Add basic and extended rates */
 	max_rate = 0;
 	p = custom;
@@ -216,33 +170,15 @@ static inline char *rtl819x_translate_scan(struct ieee80211_device *ieee,
 		if (rate > max_rate)
 			max_rate = rate;
 	}
-#if 0
-	printk("max rate:%d ===basic rate:\n", max_rate);
-	for (i=0;i<network->rates_len;i++)
-		printk(" %x", network->rates[i]);
-	printk("\n=======extend rate\n");
-	for (i=0; i<network->rates_ex_len; i++)
-		printk(" %x", network->rates_ex[i]);
-	printk("\n");
-#endif
 	iwe.cmd = SIOCGIWRATE;
 	iwe.u.bitrate.fixed = iwe.u.bitrate.disabled = 0;
 	iwe.u.bitrate.value = max_rate * 500000;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)
         start = iwe_stream_add_event_rsl(info, start, stop, &iwe,
 				     IW_EV_PARAM_LEN);
-#else
-        start = iwe_stream_add_event_rsl(start, stop, &iwe,
-				     IW_EV_PARAM_LEN);
-#endif
 	iwe.cmd = IWEVCUSTOM;
 	iwe.u.data.length = p - custom;
 	if (iwe.u.data.length)
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)
         start = iwe_stream_add_point(info, start, stop, &iwe, custom);
-#else
-        start = iwe_stream_add_point(start, stop, &iwe, custom);
-#endif
 	/* Add quality statistics */
 	/* TODO: Fix these values... */
 	iwe.cmd = IWEVQUAL;
@@ -257,21 +193,13 @@ static inline char *rtl819x_translate_scan(struct ieee80211_device *ieee,
 	if (!(network->stats.mask & IEEE80211_STATMASK_SIGNAL))
 		iwe.u.qual.updated |= IW_QUAL_QUAL_INVALID;
 	iwe.u.qual.updated = 7;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)
         start = iwe_stream_add_event_rsl(info, start, stop, &iwe, IW_EV_QUAL_LEN);
-#else
-        start = iwe_stream_add_event_rsl(start, stop, &iwe, IW_EV_QUAL_LEN);
-#endif
 	iwe.cmd = IWEVCUSTOM;
 	p = custom;
 
 	iwe.u.data.length = p - custom;
 	if (iwe.u.data.length)
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)
             start = iwe_stream_add_point(info, start, stop, &iwe, custom);
-#else
-            start = iwe_stream_add_point(start, stop, &iwe, custom);
-#endif
 #if (WIRELESS_EXT < 18)
 	if (ieee->wpa_enabled && network->wpa_ie_len){
 		char buf[MAX_WPA_IE_LEN * 2 + 30];
@@ -285,11 +213,7 @@ static inline char *rtl819x_translate_scan(struct ieee80211_device *ieee,
 		memset(&iwe, 0, sizeof(iwe));
 		iwe.cmd = IWEVCUSTOM;
 		iwe.u.data.length = strlen(buf);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)
                 start = iwe_stream_add_point(info, start, stop, &iwe, buf);
-#else
-                start = iwe_stream_add_point(start, stop, &iwe, buf);
-#endif
         }
 
 	if (ieee->wpa_enabled && network->rsn_ie_len){
@@ -304,11 +228,7 @@ static inline char *rtl819x_translate_scan(struct ieee80211_device *ieee,
 		memset(&iwe, 0, sizeof(iwe));
 		iwe.cmd = IWEVCUSTOM;
 		iwe.u.data.length = strlen(buf);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)
                 start = iwe_stream_add_point(info, start, stop, &iwe, buf);
-#else
-                start = iwe_stream_add_point(start, stop, &iwe, buf);
-#endif
         }
 #else
 	memset(&iwe, 0, sizeof(iwe));
@@ -318,11 +238,7 @@ static inline char *rtl819x_translate_scan(struct ieee80211_device *ieee,
 		memcpy(buf, network->wpa_ie, network->wpa_ie_len);
 		iwe.cmd = IWEVGENIE;
 		iwe.u.data.length = network->wpa_ie_len;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)
                 start = iwe_stream_add_point(info, start, stop, &iwe, buf);
-#else
-                start = iwe_stream_add_point(start, stop, &iwe, buf);
-#endif
         }
 	memset(&iwe, 0, sizeof(iwe));
 	if (network->rsn_ie_len)
@@ -331,11 +247,7 @@ static inline char *rtl819x_translate_scan(struct ieee80211_device *ieee,
 		memcpy(buf, network->rsn_ie, network->rsn_ie_len);
 		iwe.cmd = IWEVGENIE;
 		iwe.u.data.length = network->rsn_ie_len;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)
                 start = iwe_stream_add_point(info, start, stop, &iwe, buf);
-#else
-                start = iwe_stream_add_point(start, stop, &iwe, buf);
-#endif
         }
 #endif
 
@@ -348,11 +260,7 @@ static inline char *rtl819x_translate_scan(struct ieee80211_device *ieee,
 		      " Last beacon: %lums ago", (jiffies - network->last_scanned) / (HZ / 100));
 	iwe.u.data.length = p - custom;
 	if (iwe.u.data.length)
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)
             start = iwe_stream_add_point(info, start, stop, &iwe, custom);
-#else
-            start = iwe_stream_add_point(start, stop, &iwe, custom);
-#endif
 
 	return start;
 }
@@ -632,7 +540,6 @@ int ieee80211_wx_set_encode_ext(struct ieee80211_device *ieee,
                                union iwreq_data *wrqu, char *extra)
 {
 	int ret = 0;
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
 	struct net_device *dev = ieee->dev;
         struct iw_point *encoding = &wrqu->encoding;
         struct iw_encode_ext *ext = (struct iw_encode_ext *)extra;
@@ -807,7 +714,6 @@ done:
                 IEEE80211_DEBUG_WX("%s: reset_port failed\n", dev->name);
                 return -EINVAL;
         }
-#endif
         return ret;
 }
 
@@ -870,7 +776,6 @@ int ieee80211_wx_set_mlme(struct ieee80211_device *ieee,
                                struct iw_request_info *info,
                                union iwreq_data *wrqu, char *extra)
 {
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
 	struct iw_mlme *mlme = (struct iw_mlme *) extra;
 	switch (mlme->cmd) {
         case IW_MLME_DEAUTH:
@@ -880,7 +785,6 @@ int ieee80211_wx_set_mlme(struct ieee80211_device *ieee,
 	 default:
                 return -EOPNOTSUPP;
         }
-#endif
 	return 0;
 }
 
@@ -888,7 +792,6 @@ int ieee80211_wx_set_auth(struct ieee80211_device *ieee,
                                struct iw_request_info *info,
                                struct iw_param *data, char *extra)
 {
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
 	switch (data->flags & IW_AUTH_INDEX) {
         case IW_AUTH_WPA_VERSION:
 	     /*need to support wpa2 here*/
@@ -946,23 +849,12 @@ int ieee80211_wx_set_auth(struct ieee80211_device *ieee,
 	default:
                 return -EOPNOTSUPP;
 	}
-#endif
 	return 0;
 }
 #endif
 #if 1
 int ieee80211_wx_set_gen_ie(struct ieee80211_device *ieee, u8 *ie, size_t len)
 {
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
-#if 0
-	printk("====>%s()\n", __FUNCTION__);
-	{
-		int i;
-		for (i=0; i<len; i++)
-		printk("%2x ", ie[i]&0xff);
-		printk("\n");
-	}
-#endif
 	u8 *buf;
 
 	if (len>MAX_WPA_IE_LEN || (len && ie == NULL))
@@ -992,29 +884,9 @@ int ieee80211_wx_set_gen_ie(struct ieee80211_device *ieee, u8 *ie, size_t len)
 		ieee->wpa_ie = NULL;
 		ieee->wpa_ie_len = 0;
 	}
-#endif
 	return 0;
 
 }
 #endif
 
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0))
-//EXPORT_SYMBOL(ieee80211_wx_set_gen_ie);
-#if (WIRELESS_EXT >= 18)
-//EXPORT_SYMBOL(ieee80211_wx_set_mlme);
-//EXPORT_SYMBOL(ieee80211_wx_set_auth);
-//EXPORT_SYMBOL(ieee80211_wx_set_encode_ext);
-//EXPORT_SYMBOL(ieee80211_wx_get_encode_ext);
-#endif
-//EXPORT_SYMBOL(ieee80211_wx_get_scan);
-//EXPORT_SYMBOL(ieee80211_wx_set_encode);
-//EXPORT_SYMBOL(ieee80211_wx_get_encode);
-#else
-//EXPORT_SYMBOL_NOVERS(ieee80211_wx_set_gen_ie);
-//EXPORT_SYMBOL_NOVERS(ieee80211_wx_set_mlme);
-//EXPORT_SYMBOL_NOVERS(ieee80211_wx_set_auth);
-//EXPORT_SYMBOL_NOVERS(ieee80211_wx_set_encode_ext);
-//EXPORT_SYMBOL_NOVERS(ieee80211_wx_get_scan);
-//EXPORT_SYMBOL_NOVERS(ieee80211_wx_set_encode);
-//EXPORT_SYMBOL_NOVERS(ieee80211_wx_get_encode);
-#endif
+
diff --git a/drivers/staging/rtl8192e/ieee80211/rtl819x_HTProc.c b/drivers/staging/rtl8192e/ieee80211/rtl819x_HTProc.c
index 4c4b1df..2532992 100644
--- a/drivers/staging/rtl8192e/ieee80211/rtl819x_HTProc.c
+++ b/drivers/staging/rtl8192e/ieee80211/rtl819x_HTProc.c
@@ -1024,17 +1024,6 @@ u8 HTFilterMCSRate( struct ieee80211_device* ieee, u8* pSupportMCS, u8* pOperate
 	return true;
 }
 void HTSetConnectBwMode(struct ieee80211_device* ieee, HT_CHANNEL_WIDTH	Bandwidth, HT_EXTCHNL_OFFSET	Offset);
-#if 0
-//I need move this function to other places, such as rx?
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
-void HTOnAssocRsp_wq(struct work_struct *work)
-{
-	struct ieee80211_device *ieee = container_of(work, struct ieee80211_device, ht_onAssRsp);
-#else
-void HTOnAssocRsp_wq(struct ieee80211_device *ieee)
-{
-#endif
-#endif
 void HTOnAssocRsp(struct ieee80211_device *ieee)
 {
 	PRT_HIGH_THROUGHPUT	pHTInfo = ieee->pHTInfo;
@@ -1761,8 +1750,4 @@ void HTSetConnectBwModeCallback(struct ieee80211_device* ieee)
 	pHTInfo->bSwBwInProgress = false;
 }
 
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-//EXPORT_SYMBOL_NOVERS(HTUpdateSelfAndPeerSetting);
-#else
-//EXPORT_SYMBOL(HTUpdateSelfAndPeerSetting);
-#endif
+
diff --git a/drivers/staging/rtl8192su/r8192SU_led.c b/drivers/staging/rtl8192su/r8192SU_led.c
index 609dba6..5d96b35 100644
--- a/drivers/staging/rtl8192su/r8192SU_led.c
+++ b/drivers/staging/rtl8192su/r8192SU_led.c
@@ -1087,22 +1087,13 @@ BlinkTimerCallback(
 	struct net_device 	*dev = (struct net_device *)data;
 	struct r8192_priv 	*priv = ieee80211_priv(dev);
 
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
 	schedule_work(&(priv->BlinkWorkItem));
-#endif
 }
 
 
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20)
 void BlinkWorkItemCallback(struct work_struct *work)
 {
 	struct r8192_priv *priv = container_of(work, struct r8192_priv, BlinkWorkItem);
-#else
-void BlinkWorkItemCallback(void * Context)
-{
-	struct net_device *dev = (struct net_device *)Context;
-	struct r8192_priv *priv = ieee80211_priv(dev);
-#endif
 
 	PLED_819xUsb	 pLed = priv->pLed;
 
-- 
1.6.4.2

