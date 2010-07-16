Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935662Ab0GPGb1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 02:31:27 -0400
Received: from web94905.mail.in2.yahoo.com ([203.104.17.152]:37595 "HELO
	web94905.mail.in2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S935636Ab0GPGbY convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 02:31:24 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Jul 2010 02:31:23 EDT
Message-ID: <662196.81557.qm@web94905.mail.in2.yahoo.com>
X-YMail-OSG: xpxE5RgVM1lqLn9dNthBLJqv.nStkYwe4ptjWbkkHURWdL9
 lcSxvhcFii6MNfWeFYvoRsJxCiftulSDwz73.hCw6D.8zmjvx.ilZY_oXVi5
 m8BJKI0C2fIX6OD5ILuIXZYRilbiITIANjP5o7CYMnCWHCz8G8UlKgQInDZq
 .MOw1iNlQRUvsNSlBXujAKpsoypQLkDnsHX_0AAPXzwJ0O0Omqkk3YPyzHNs
 SJRohlbB3k4l8eAzUCDiuGNKFuKPnbyYGOi2RPVQgi9mu5OZO3z3_TY4eu94
 aqUIUKlrsk0A6AwzTQ98U
X-RocketYMMF: pavan_savoy
X-Mailer: YahooMailClassic/11.2.4 YahooMailWebService/0.8.104.276605
Date: Fri, 16 Jul 2010 11:54:40 +0530 (IST)
From: Pavan Savoy <pavan_savoy@ti.com>
Reply-To: pavan_savoy@ti.com
Subject: Re: [PATCH] drivers:staging:ti-st: make use of linux err codes
To: greg <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTikrtkVSWZoyVL6A0Maa16cKxGUnnuyrRGmpU09z@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--- On Fri, 16/7/10, Pavan Savoy <pavan.savoy@gmail.com> wrote:

> From: Pavan Savoy <pavan.savoy@gmail.com>
> Subject: [PATCH] drivers:staging:ti-st: make use of linux err codes
> To: "pavan savoy" <pavan_savoy@yahoo.co.in>
> Date: Friday, 16 July, 2010, 11:52 AM
> ---------- Forwarded message
> ----------
> From:  <pavan_savoy@ti.com>
> Date: Wed, Jul 14, 2010 at 6:51 PM
> Subject: [PATCH] drivers:staging:ti-st: make use of linux
> err codes
> To: alan@lxorguk.ukuu.org.uk,
> gregkh@suse.de
> Cc: devel@driverdev.osuosl.org,
> linux-kernel@vger.kernel.org,

Greg,
Any comments ? Is it good to go ?

> 
> remove custom error code definitions from the header and
> make use of the agreed upon linux error codes.
> 
> Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
> ---
>  drivers/staging/ti-st/bt_drv.c  |    6 ++--
>  drivers/staging/ti-st/st.h      |    9 -------
>  drivers/staging/ti-st/st_core.c |   38
> ++++++++++++++++----------------
>  drivers/staging/ti-st/st_kim.c  |   46
> +++++++++++++++++++-------------------
>  drivers/staging/ti-st/st_ll.c   |    4 +-
>  5 files changed, 47 insertions(+), 56 deletions(-)
> 
> diff --git a/drivers/staging/ti-st/bt_drv.c
> b/drivers/staging/ti-st/bt_drv.c
> index d8420b5..d70aea1 100644
> --- a/drivers/staging/ti-st/bt_drv.c
> +++ b/drivers/staging/ti-st/bt_drv.c
> @@ -191,7 +191,7 @@ static int hci_st_open(struct hci_dev
> *hdev)
> 
>        /* Register with ST layer */
>        err = st_register(&hci_st_proto);
> -       if (err == ST_ERR_PENDING) {
> +       if (err == -EINPROGRESS) {
>                /* Prepare wait-for-completion
> handler data structures.
>                 * Needed to syncronize this and
> st_registration_completion_cb()
>                 * functions.
> @@ -232,7 +232,7 @@ static int hci_st_open(struct hci_dev
> *hdev)
>                        return -EAGAIN;
>                }
>                err = 0;
> -       } else if (err == ST_ERR_FAILURE) {
> +       } else if (err == -1) {
>                BT_DRV_ERR("st_register failed %d",
> err);
>                BTDRV_API_EXIT(-EAGAIN);
>                return -EAGAIN;
> @@ -280,7 +280,7 @@ static int hci_st_close(struct hci_dev
> *hdev)
>        /* Unregister from ST layer */
>        if (test_and_clear_bit(BT_ST_REGISTERED,
> &hst->flags)) {
>                err = st_unregister(ST_BT);
> -               if (err != ST_SUCCESS) {
> +               if (err != 0) {
>                      
>  BT_DRV_ERR("st_unregister failed %d", err);
>                        BTDRV_API_EXIT(-EBUSY);
>                        return -EBUSY;
> diff --git a/drivers/staging/ti-st/st.h
> b/drivers/staging/ti-st/st.h
> index e6a8ffd..c4288aa 100644
> --- a/drivers/staging/ti-st/st.h
> +++ b/drivers/staging/ti-st/st.h
> @@ -50,15 +50,6 @@ enum proto_type {
>        ST_MAX,
>  };
> 
> -enum {
> -       ST_ERR_FAILURE = -1,    /* check struct */
> -       ST_SUCCESS,
> -       ST_ERR_PENDING = -5,    /* to call
> reg_complete_cb */
> -       ST_ERR_ALREADY,         /* already
> registered */
> -       ST_ERR_INPROGRESS,
> -       ST_ERR_NOPROTO,         /* protocol not
> supported */
> -};
> -
>  /* per protocol structure
>  * for BT/FM and GPS
>  */
> diff --git a/drivers/staging/ti-st/st_core.c
> b/drivers/staging/ti-st/st_core.c
> index bf5049c..0ad8cec 100644
> --- a/drivers/staging/ti-st/st_core.c
> +++ b/drivers/staging/ti-st/st_core.c
> @@ -87,7 +87,7 @@ int st_int_write(struct st_data_s
> *st_gdata,
>        struct tty_struct *tty;
>        if (unlikely(st_gdata == NULL ||
> st_gdata->tty == NULL)) {
>                pr_err("tty unavailable to perform
> write");
> -               return ST_ERR_FAILURE;
> +               return -1;
>        }
>        tty = st_gdata->tty;
>  #ifdef VERBOSE
> @@ -123,7 +123,7 @@ void st_send_frame(enum proto_type
> protoid, struct
> st_data_s *st_gdata)
>         */
>        if (likely(st_gdata->list[protoid]->recv
> != NULL)) {
>                if
> (unlikely(st_gdata->list[protoid]->recv(st_gdata->rx_skb)
> -                            != ST_SUCCESS))
> {

> +                            != 0)) {
>                        pr_err(" proto stack
> %d's ->recv failed", protoid);
>                      
>  kfree_skb(st_gdata->rx_skb);
>                        return;
> @@ -601,7 +601,7 @@ void kim_st_list_protocols(struct
> st_data_s
> *st_gdata, char *buf)
>  long st_register(struct st_proto_s *new_proto)
>  {
>        struct st_data_s        *st_gdata;
> -       long err = ST_SUCCESS;
> +       long err = 0;
>        unsigned long flags = 0;
> 
>        st_kim_ref(&st_gdata);
> @@ -609,17 +609,17 @@ long st_register(struct st_proto_s
> *new_proto)
>        if (st_gdata == NULL || new_proto == NULL ||
> new_proto->recv == NULL
>            || new_proto->reg_complete_cb == NULL)
> {
>                pr_err("gdata/new_proto/recv or
> reg_complete_cb not ready");
> -               return ST_ERR_FAILURE;
> +               return -1;
>        }
> 
>        if (new_proto->type < ST_BT ||
> new_proto->type >= ST_MAX) {
>                pr_err("protocol %d not supported",
> new_proto->type);
> -               return ST_ERR_NOPROTO;
> +               return -EPROTONOSUPPORT;
>        }
> 
>        if (st_gdata->list[new_proto->type] !=
> NULL) {
>                pr_err("protocol %d already
> registered", new_proto->type);
> -               return ST_ERR_ALREADY;
> +               return -EALREADY;
>        }
> 
>        /* can be from process context only */
> @@ -636,7 +636,7 @@ long st_register(struct st_proto_s
> *new_proto)
> 
>                set_bit(ST_REG_PENDING,
> &st_gdata->st_state);
>              
>  spin_unlock_irqrestore(&st_gdata->lock, flags);
> -               return ST_ERR_PENDING;
> +               return -EINPROGRESS;
>        } else if (st_gdata->protos_registered ==
> ST_EMPTY) {
>                pr_info(" protocol list empty :%d ",
> new_proto->type);
>                set_bit(ST_REG_IN_PROGRESS,
> &st_gdata->st_state);
> @@ -651,15 +651,15 @@ long st_register(struct st_proto_s
> *new_proto)
>                 * since it involves BT fw download
>                 */
>                err =
> st_kim_start(st_gdata->kim_data);
> -               if (err != ST_SUCCESS) {
> +               if (err != 0) {
>                      
>  clear_bit(ST_REG_IN_PROGRESS,
> &st_gdata->st_state);
>                        if
> ((st_gdata->protos_registered != ST_EMPTY) &&
>                          
>  (test_bit(ST_REG_PENDING, &st_gdata->st_state))) {
>                                pr_err(" KIM
> failure complete callback ");
> -                              
> st_reg_complete(st_gdata, ST_ERR_FAILURE);
> +                              
> st_reg_complete(st_gdata, -1);
>                        }
> 
> -                       return ST_ERR_FAILURE;
> +                       return -1;
>                }
> 
>                /* the protocol might require other
> gpios to be toggled
> @@ -675,7 +675,7 @@ long st_register(struct st_proto_s
> *new_proto)
>                if ((st_gdata->protos_registered
> != ST_EMPTY) &&
>                    (test_bit(ST_REG_PENDING,
> &st_gdata->st_state))) {
>                        pr_info(" call reg
> complete callback ");
> -                      
> st_reg_complete(st_gdata, ST_SUCCESS);
> +                      
> st_reg_complete(st_gdata, 0);
>                }
>                clear_bit(ST_REG_PENDING,
> &st_gdata->st_state);
> 
> @@ -685,7 +685,7 @@ long st_register(struct st_proto_s
> *new_proto)
>                if
> (st_gdata->list[new_proto->type] != NULL) {
>                        pr_err(" proto %d
> already registered ",
>                                  
> new_proto->type);
> -                       return ST_ERR_ALREADY;
> +                       return -EALREADY;
>                }
> 
>              
>  spin_lock_irqsave(&st_gdata->lock, flags);
> @@ -709,7 +709,7 @@ long st_register(struct st_proto_s
> *new_proto)
>                default:
>                        pr_err("%d protocol not
> supported",
>                                  
> new_proto->type);
> -                       err = ST_ERR_NOPROTO;
> +                       err = -EPROTONOSUPPORT;
>                        /* something wrong */
>                        break;
>                }
> @@ -730,7 +730,7 @@ EXPORT_SYMBOL_GPL(st_register);
>  */
>  long st_unregister(enum proto_type type)
>  {
> -       long err = ST_SUCCESS;
> +       long err = 0;
>        unsigned long flags = 0;
>        struct st_data_s        *st_gdata;
> 
> @@ -739,7 +739,7 @@ long st_unregister(enum proto_type
> type)
>        st_kim_ref(&st_gdata);
>        if (type < ST_BT || type >= ST_MAX) {
>                pr_err(" protocol %d not supported",
> type);
> -               return ST_ERR_NOPROTO;
> +               return -EPROTONOSUPPORT;
>        }
> 
>        spin_lock_irqsave(&st_gdata->lock,
> flags);
> @@ -747,7 +747,7 @@ long st_unregister(enum proto_type
> type)
>        if (st_gdata->list[type] == NULL) {
>                pr_err(" protocol %d not
> registered", type);
>              
>  spin_unlock_irqrestore(&st_gdata->lock, flags);
> -               return ST_ERR_NOPROTO;
> +               return -EPROTONOSUPPORT;
>        }
> 
>        st_gdata->protos_registered--;
> @@ -794,7 +794,7 @@ long st_write(struct sk_buff *skb)
>        if (unlikely(skb == NULL || st_gdata == NULL
>                || st_gdata->tty == NULL)) {
>                pr_err("data/tty unavailable to
> perform write");
> -               return ST_ERR_FAILURE;
> +               return -1;
>        }
>  #ifdef DEBUG                   /* open-up skb to
> read the 1st byte */
>        switch (skb->data[0]) {
> @@ -813,7 +813,7 @@ long st_write(struct sk_buff *skb)
>        if (unlikely(st_gdata->list[protoid] ==
> NULL)) {
>                pr_err(" protocol %d not registered,
> and writing? ",
>                           protoid);
> -               return ST_ERR_FAILURE;
> +               return -1;
>        }
>  #endif
>        pr_info("%d to be written", skb->len);
> @@ -837,7 +837,7 @@ EXPORT_SYMBOL_GPL(st_unregister);
>  */
>  static int st_tty_open(struct tty_struct *tty)
>  {
> -       int err = ST_SUCCESS;
> +       int err = 0;
>        struct st_data_s *st_gdata;
>        pr_info("%s ", __func__);
> 
> diff --git a/drivers/staging/ti-st/st_kim.c
> b/drivers/staging/ti-st/st_kim.c
> index d4fd2c2..33fc4d0 100644
> --- a/drivers/staging/ti-st/st_kim.c
> +++ b/drivers/staging/ti-st/st_kim.c
> @@ -247,13 +247,13 @@ static long read_local_version(struct
> kim_data_s
> *kim_gdata, char *bts_scr_name)
>        INIT_COMPLETION(kim_gdata->kim_rcvd);
>        if (4 != st_int_write(kim_gdata->core_data,
> read_ver_cmd, 4)) {
>                pr_err("kim: couldn't write 4
> bytes");
> -               return ST_ERR_FAILURE;
> +               return -1;
>        }
> 
>        if (!wait_for_completion_timeout
>            (&kim_gdata->kim_rcvd,
> msecs_to_jiffies(CMD_RESP_TIME))) {
>                pr_err(" waiting for ver info- timed
> out ");
> -               return ST_ERR_FAILURE;
> +               return -1;
>        }
> 
>        version =
> @@ -275,7 +275,7 @@ static long read_local_version(struct
> kim_data_s
> *kim_gdata, char *bts_scr_name)
>        kim_gdata->version.min_ver = min_ver;
> 
>        pr_info("%s", bts_scr_name);
> -       return ST_SUCCESS;
> +       return 0;
>  }
> 
>  /* internal function which parses through the .bts
> firmware script file
> @@ -283,7 +283,7 @@ static long read_local_version(struct
> kim_data_s
> *kim_gdata, char *bts_scr_name)
>  */
>  static long download_firmware(struct kim_data_s
> *kim_gdata)
>  {
> -       long err = ST_SUCCESS;
> +       long err = 0;
>        long len = 0;
>        register unsigned char *ptr = NULL;
>        register unsigned char *action_ptr = NULL;
> @@ -292,7 +292,7 @@ static long download_firmware(struct
> kim_data_s *kim_gdata)
>        pr_info("%s", __func__);
> 
>        err = read_local_version(kim_gdata,
> bts_scr_name);
> -       if (err != ST_SUCCESS) {
> +       if (err != 0) {
>                pr_err("kim: failed to read local
> ver");
>                return err;
>        }
> @@ -303,7 +303,7 @@ static long download_firmware(struct
> kim_data_s *kim_gdata)
>                    
> (kim_gdata->fw_entry->size == 0))) {
>                pr_err(" request_firmware
> failed(errno %ld) for %s", err,
>                           bts_scr_name);
> -               return ST_ERR_FAILURE;
> +               return -1;
>        }
>        ptr = (void *)kim_gdata->fw_entry->data;
>        len = kim_gdata->fw_entry->size;
> @@ -338,7 +338,7 @@ static long download_firmware(struct
> kim_data_s *kim_gdata)
>                                        
>   ((struct bts_action *)ptr)->size);
>                        if (unlikely(err <
> 0)) {
>                              
>  release_firmware(kim_gdata->fw_entry);
> -                               return
> ST_ERR_FAILURE;
> +                               return -1;
>                        }
>                        if
> (!wait_for_completion_timeout
>                          
>  (&kim_gdata->kim_rcvd,
> @@ -347,7 +347,7 @@ static long download_firmware(struct
> kim_data_s *kim_gdata)
>                                    ("
> response timeout during fw download ");
>                                /* timed out
> */
>                              
>  release_firmware(kim_gdata->fw_entry);
> -                               return
> ST_ERR_FAILURE;
> +                               return -1;
>                        }
>                        break;
>                case ACTION_DELAY:      /* sleep
> */
> @@ -365,7 +365,7 @@ static long download_firmware(struct
> kim_data_s *kim_gdata)
>        }
>        /* fw download complete */
>        release_firmware(kim_gdata->fw_entry);
> -       return ST_SUCCESS;
> +       return 0;
>  }
> 
>  /**********************************************************************/
> @@ -451,7 +451,7 @@ void st_kim_complete(void *kim_data)
>  */
>  long st_kim_start(void *kim_data)
>  {
> -       long err = ST_SUCCESS;
> +       long err = 0;
>        long retry = POR_RETRY_COUNT;
>        struct kim_data_s       *kim_gdata = (struct
> kim_data_s *)kim_data;
> 
> @@ -475,7 +475,7 @@ long st_kim_start(void *kim_data)
>                err =
> kill_pid(find_get_pid(kim_gdata->uim_pid), SIGUSR2, 0);
>                if (err != 0) {
>                        pr_info(" sending
> SIGUSR2 to uim failed %ld", err);
> -                       err = ST_ERR_FAILURE;
> +                       err = -1;
>                        continue;
>                }
>  #endif
> @@ -486,13 +486,13 @@ long st_kim_start(void *kim_data)
>                              
>  msecs_to_jiffies(LDISC_TIME));
>                if (!err) {     /* timeout */
>                        pr_err("line disc
> installation timed out ");
> -                       err = ST_ERR_FAILURE;
> +                       err = -1;
>                        continue;
>                } else {
>                        /* ldisc installed now
> */
>                        pr_info(" line
> discipline installed ");
>                        err =
> download_firmware(kim_gdata);
> -                       if (err != ST_SUCCESS)
> {
> +                       if (err != 0) {
>                              
>  pr_err("download firmware failed");
>                                continue;
>                        } else {        /*
> on success don't retry */
> @@ -507,7 +507,7 @@ long st_kim_start(void *kim_data)
>  */
>  long st_kim_stop(void *kim_data)
>  {
> -       long err = ST_SUCCESS;
> +       long err = 0;
>        struct kim_data_s       *kim_gdata = (struct
> kim_data_s *)kim_data;
> 
>        INIT_COMPLETION(kim_gdata->ldisc_installed);
> @@ -516,7 +516,7 @@ long st_kim_stop(void *kim_data)
>        err =
> kill_pid(find_get_pid(kim_gdata->uim_pid), SIGUSR2, 1);
>        if (err != 0) {
>                pr_err("sending SIGUSR2 to uim
> failed %ld", err);
> -               return ST_ERR_FAILURE;
> +               return -1;
>        }
>  #endif
>        /* set BT rfkill to be blocked */
> @@ -527,7 +527,7 @@ long st_kim_stop(void *kim_data)
>                      
>  msecs_to_jiffies(LDISC_TIME));
>        if (!err) {             /* timeout */
>                pr_err(" timed out waiting for ldisc
> to be un-installed");
> -               return ST_ERR_FAILURE;
> +               return -1;
>        }
> 
>        /* By default configure BT nShutdown to LOW
> state */
> @@ -607,7 +607,7 @@ static int kim_toggle_radio(void *data,
> bool blocked)
>                pr_err(" wrong proto type ");
>        break;
>        }
> -       return ST_SUCCESS;
> +       return 0;
>  }
> 
>  void st_kim_ref(struct st_data_s **core_data)
> @@ -643,7 +643,7 @@ static int kim_probe(struct
> platform_device *pdev)
>        status =
> st_core_init(&kim_gdata->core_data);
>        if (status != 0) {
>                pr_err(" ST core init failed");
> -               return ST_ERR_FAILURE;
> +               return -1;
>        }
>        /* refer to itself */
>        kim_gdata->core_data->kim_data =
> kim_gdata;
> @@ -716,7 +716,7 @@ static int kim_probe(struct
> platform_device *pdev)
>                return -1;
>        }
>        pr_info(" sysfs entries created ");
> -       return ST_SUCCESS;
> +       return 0;
>  }
> 
>  static int kim_remove(struct platform_device *pdev)
> @@ -745,7 +745,7 @@ static int kim_remove(struct
> platform_device *pdev)
> 
>        kfree(kim_gdata);
>        kim_gdata = NULL;
> -       return ST_SUCCESS;
> +       return 0;
>  }
> 
>  /**********************************************************************/
> @@ -753,13 +753,13 @@ static int kim_remove(struct
> platform_device *pdev)
> 
>  static int __init st_kim_init(void)
>  {
> -       long ret = ST_SUCCESS;
> +       long ret = 0;
>        ret =
> platform_driver_register(&kim_platform_driver);
>        if (ret != 0) {
>                pr_err("platform drv registration
> failed");
> -               return ST_ERR_FAILURE;
> +               return -1;
>        }
> -       return ST_SUCCESS;
> +       return 0;
>  }
> 
>  static void __exit st_kim_deinit(void)
> diff --git a/drivers/staging/ti-st/st_ll.c
> b/drivers/staging/ti-st/st_ll.c
> index 0685a10..6bc0759 100644
> --- a/drivers/staging/ti-st/st_ll.c
> +++ b/drivers/staging/ti-st/st_ll.c
> @@ -127,9 +127,9 @@ unsigned long st_ll_sleep_state(struct
> st_data_s *st_data,
>                break;
>        default:
>                pr_err(" unknown input/state ");
> -               return ST_ERR_FAILURE;
> +               return -1;
>        }
> -       return ST_SUCCESS;
> +       return 0;
>  }
> 
>  /* Called from ST CORE to initialize ST LL */
> --
> 1.5.6.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 
> 
> 
> -- 
> --Pavan Savoy
> 


