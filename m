Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932801Ab1KPAwy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 19:52:54 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60404 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932745Ab1KPAww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 19:52:52 -0500
MIME-Version: 1.0
In-Reply-To: <631c53d126feff0a99b61d9c9a00b308d2b638ee.1321398815.git.joe@perches.com>
References: <cover.1321398814.git.joe@perches.com>
	<631c53d126feff0a99b61d9c9a00b308d2b638ee.1321398815.git.joe@perches.com>
Date: Wed, 16 Nov 2011 09:52:48 +0900
Message-ID: <CAKYAXd_wtGVQYgr_MUtVGGpkpqJgF56bfm0zO-nnAK0YpkT+bg@mail.gmail.com>
Subject: Re: [PATCH 4/4] mmc: Add mmc_host_<level> logging
From: NamJae Jeon <linkinjeon@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Nicolas Ferre <nicolas.ferre@atmel.com>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Nicolas Pitre <nico@fluxnic.net>, Chris Ball <cjb@laptop.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Ian Molton <ian@mnementh.co.uk>, Bruce Chang <brucechang@via.com.tw>,
        Harald Welte <HaraldWelte@viatech.com>,
        Pierre Ossman <pierre@ossman.eu>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-omap@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pAG0rDi5026920

2011/11/16 Joe Perches <joe@perches.com>:
> Centralize the pr_<level> uses of mmc_hostname into specific
> mmc_host_<level> calls to allow a flexible presentation style
> and shorten the code a bit.
>
> Add mmc_host_<level> macros.
> Convert the logging calls from:
>        pr_<level>("%s: ...", mmc_hostname(foo)
> to:
>        mmc_host_<level>(foo, ...)
>
> Add a couple of missing newlines.
> Convert bare printks to pr_cont where appropriate.
> Spelling/typo fix of initialiazed to initialized.
>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/mmc/card/mmc_test.c     |   66 +++++++++++---------------
>  drivers/mmc/core/bus.c          |   27 +++++------
>  drivers/mmc/core/core.c         |  101 ++++++++++++++++++---------------------
>  drivers/mmc/core/host.c         |   13 ++---
>  drivers/mmc/core/mmc.c          |   67 ++++++++++---------------
>  drivers/mmc/core/mmc_ops.c      |   11 ++--
>  drivers/mmc/core/sd.c           |   62 ++++++++---------------
>  drivers/mmc/core/sdio.c         |   10 ++--
>  drivers/mmc/core/sdio_cis.c     |    9 ++--
>  drivers/mmc/core/sdio_irq.c     |    7 +--
>  drivers/mmc/host/at91_mci.c     |    9 ++--
>  drivers/mmc/host/dw_mmc.c       |    2 +-
>  drivers/mmc/host/msm_sdcc.c     |  101 ++++++++++++++++++---------------------
>  drivers/mmc/host/mvsdio.c       |   35 ++++++--------
>  drivers/mmc/host/omap_hsmmc.c   |    7 +--
>  drivers/mmc/host/pxamci.c       |    4 +-
>  drivers/mmc/host/sdhci.c        |   81 +++++++++++++------------------
>  drivers/mmc/host/tmio_mmc.c     |    4 +-
>  drivers/mmc/host/tmio_mmc_pio.c |    4 +-
>  drivers/mmc/host/via-sdmmc.c    |   21 ++++-----
>  drivers/mmc/host/wbsd.c         |   27 +++++-----
>  include/linux/mmc/host.h        |   11 ++++
>  22 files changed, 298 insertions(+), 381 deletions(-)
>
> diff --git a/drivers/mmc/card/mmc_test.c b/drivers/mmc/card/mmc_test.c
> index f079555..5a263c6 100644
> --- a/drivers/mmc/card/mmc_test.c
> +++ b/drivers/mmc/card/mmc_test.c
> @@ -253,8 +253,7 @@ static int mmc_test_wait_busy(struct mmc_test_card *test)
>                if (!busy && mmc_test_busy(&cmd)) {
>                        busy = 1;
>                        if (test->card->host->caps & MMC_CAP_WAIT_WHILE_BUSY)
> -                               pr_info("%s: Warning: Host did not wait for busy state to end\n",
> -                                       mmc_hostname(test->card->host));
> +                               mmc_host_info(test->card->host, "Warning: Host did not wait for busy state to end\n");
>                }
>        } while (mmc_test_busy(&cmd));
>
> @@ -554,11 +553,11 @@ static void mmc_test_print_rate(struct mmc_test_card *test, uint64_t bytes,
>        rate = mmc_test_rate(bytes, &ts);
>        iops = mmc_test_rate(100, &ts); /* I/O ops per sec x 100 */
>
> -       pr_info("%s: Transfer of %u sectors (%u%s KiB) took %lu.%09lu seconds (%u kB/s, %u KiB/s, %u.%02u IOPS)\n",
> -               mmc_hostname(test->card->host), sectors, sectors >> 1,
> -               (sectors & 1 ? ".5" : ""), (unsigned long)ts.tv_sec,
> -               (unsigned long)ts.tv_nsec, rate / 1000, rate / 1024,
> -               iops / 100, iops % 100);
> +       mmc_host_info(test->card->host, "Transfer of %u sectors (%u%s KiB) took %lu.%09lu seconds (%u kB/s, %u KiB/s, %u.%02u IOPS)\n",
> +                     sectors, sectors >> 1,
> +                     (sectors & 1 ? ".5" : ""), (unsigned long)ts.tv_sec,
> +                     (unsigned long)ts.tv_nsec, rate / 1000, rate / 1024,
> +                     iops / 100, iops % 100);
>
>        mmc_test_save_transfer_result(test, 1, sectors, ts, rate, iops);
>  }
> @@ -579,12 +578,12 @@ static void mmc_test_print_avg_rate(struct mmc_test_card *test, uint64_t bytes,
>        rate = mmc_test_rate(tot, &ts);
>        iops = mmc_test_rate(count * 100, &ts); /* I/O ops per sec x 100 */
>
> -       pr_info("%s: Transfer of %u x %u sectors (%u x %u%s KiB) took %lu.%09lu seconds (%u kB/s, %u KiB/s, %u.%02u IOPS, sg_len %d)\n",
> -               mmc_hostname(test->card->host), count, sectors, count,
> -               sectors >> 1, (sectors & 1 ? ".5" : ""),
> -               (unsigned long)ts.tv_sec, (unsigned long)ts.tv_nsec,
> -               rate / 1000, rate / 1024, iops / 100, iops % 100,
> -               test->area.sg_len);
> +       mmc_host_info(test->card->host, "Transfer of %u x %u sectors (%u x %u%s KiB) took %lu.%09lu seconds (%u kB/s, %u KiB/s, %u.%02u IOPS, sg_len %d)\n",
> +                     count, sectors, count,
> +                     sectors >> 1, (sectors & 1 ? ".5" : ""),
> +                     (unsigned long)ts.tv_sec, (unsigned long)ts.tv_nsec,
> +                     rate / 1000, rate / 1024, iops / 100, iops % 100,
> +                     test->area.sg_len);
I don't know why pr_info should be surely replaced by mmc_host_info.
if it is needed for only host name, I think that existing
pr_info/err/debug is sufficient.

>
>        mmc_test_save_transfer_result(test, count, sectors, ts, rate, iops);
>  }
> @@ -1407,8 +1406,7 @@ static int mmc_test_multi_read_high(struct mmc_test_card *test)
>
>  static int mmc_test_no_highmem(struct mmc_test_card *test)
>  {
> -       pr_info("%s: Highmem not configured - test skipped\n",
> -               mmc_hostname(test->card->host));
> +       mmc_host_info(test->card->host, "Highmem not configured - test skipped\n");
>        return 0;
>  }
>
> @@ -1434,8 +1432,7 @@ static int mmc_test_area_map(struct mmc_test_card *test, unsigned long sz,
>                                      t->max_seg_sz, &t->sg_len, min_sg_len);
>        }
>        if (err)
> -               pr_info("%s: Failed to map sg list\n",
> -                       mmc_hostname(test->card->host));
> +               mmc_host_info(test->card->host, "Failed to map sg list\n");
>        return err;
>  }
>
> @@ -2689,8 +2686,8 @@ static void mmc_test_run(struct mmc_test_card *test, int testcase)
>  {
>        int i, ret;
>
> -       pr_info("%s: Starting tests of card %s...\n",
> -               mmc_hostname(test->card->host), mmc_card_id(test->card));
> +       mmc_host_info(test->card->host, "Starting tests of card %s...\n",
> +                     mmc_card_id(test->card));
>
>        mmc_claim_host(test->card->host);
>
> @@ -2700,16 +2697,14 @@ static void mmc_test_run(struct mmc_test_card *test, int testcase)
>                if (testcase && ((i + 1) != testcase))
>                        continue;
>
> -               pr_info("%s: Test case %d. %s...\n",
> -                       mmc_hostname(test->card->host), i + 1,
> -                       mmc_test_cases[i].name);
> +               mmc_host_info(test->card->host, "Test case %d. %s...\n",
> +                             i + 1, mmc_test_cases[i].name);
>
>                if (mmc_test_cases[i].prepare) {
>                        ret = mmc_test_cases[i].prepare(test);
>                        if (ret) {
> -                               pr_info("%s: Result: Prepare stage failed! (%d)\n",
> -                                       mmc_hostname(test->card->host),
> -                                       ret);
> +                               mmc_host_info(test->card->host, "Result: Prepare stage failed! (%d)\n",
> +                                             ret);
>                                continue;
>                        }
>                }
> @@ -2736,24 +2731,20 @@ static void mmc_test_run(struct mmc_test_card *test, int testcase)
>                ret = mmc_test_cases[i].run(test);
>                switch (ret) {
>                case RESULT_OK:
> -                       pr_info("%s: Result: OK\n",
> -                               mmc_hostname(test->card->host));
> +                       mmc_host_info(test->card->host, "Result: OK\n");
>                        break;
>                case RESULT_FAIL:
> -                       pr_info("%s: Result: FAILED\n",
> -                               mmc_hostname(test->card->host));
> +                       mmc_host_info(test->card->host, "Result: FAILED\n");
>                        break;
>                case RESULT_UNSUP_HOST:
> -                       pr_info("%s: Result: UNSUPPORTED (by host)\n",
> -                               mmc_hostname(test->card->host));
> +                       mmc_host_info(test->card->host, "Result: UNSUPPORTED (by host)\n");
>                        break;
>                case RESULT_UNSUP_CARD:
> -                       pr_info("%s: Result: UNSUPPORTED (by card)\n",
> -                               mmc_hostname(test->card->host));
> +                       mmc_host_info(test->card->host, "Result: UNSUPPORTED (by card)\n");
>                        break;
>                default:
> -                       pr_info("%s: Result: ERROR (%d)\n",
> -                               mmc_hostname(test->card->host), ret);
> +                       mmc_host_info(test->card->host, "Result: ERROR (%d)\n",
> +                                     ret);
>                }
>
>                /* Save the result */
> @@ -2763,8 +2754,7 @@ static void mmc_test_run(struct mmc_test_card *test, int testcase)
>                if (mmc_test_cases[i].cleanup) {
>                        ret = mmc_test_cases[i].cleanup(test);
>                        if (ret) {
> -                               pr_info("%s: Warning: Cleanup stage failed! (%d)\n",
> -                                       mmc_hostname(test->card->host),
> +                               mmc_host_info(test->card->host, "Warning: Cleanup stage failed! (%d)\n",
>                                        ret);
>                        }
>                }
> @@ -2772,7 +2762,7 @@ static void mmc_test_run(struct mmc_test_card *test, int testcase)
>
>        mmc_release_host(test->card->host);
>
> -       pr_info("%s: Tests completed\n", mmc_hostname(test->card->host));
> +       mmc_host_info(test->card->host, "Tests completed\n");
>  }
>
>  static void mmc_test_free_result(struct mmc_card *card)
> diff --git a/drivers/mmc/core/bus.c b/drivers/mmc/core/bus.c
> index 2e1f028..e976d85 100644
> --- a/drivers/mmc/core/bus.c
> +++ b/drivers/mmc/core/bus.c
> @@ -297,18 +297,16 @@ int mmc_add_card(struct mmc_card *card)
>        }
>
>        if (mmc_host_is_spi(card->host)) {
> -               pr_info("%s: new %s%s%s card on SPI\n",
> -                       mmc_hostname(card->host),
> -                       mmc_card_highspeed(card) ? "high speed " : "",
> -                       mmc_card_ddr_mode(card) ? "DDR " : "",
> -                       type);
> +               mmc_host_info(card->host, "new %s%s%s card on SPI\n",
> +                             mmc_card_highspeed(card) ? "high speed " : "",
> +                             mmc_card_ddr_mode(card) ? "DDR " : "",
> +                             type);
>        } else {
> -               pr_info("%s: new %s%s%s card at address %04x\n",
> -                       mmc_hostname(card->host),
> -                       mmc_sd_card_uhs(card) ? "ultra high speed " :
> -                       mmc_card_highspeed(card) ? "high speed " : "",
> -                       mmc_card_ddr_mode(card) ? "DDR " : "",
> -                       type, card->rca);
> +               mmc_host_info(card->host, "new %s%s%s card at address %04x\n",
> +                             mmc_sd_card_uhs(card) ? "ultra high speed " :
> +                             mmc_card_highspeed(card) ? "high speed " : "",
> +                             mmc_card_ddr_mode(card) ? "DDR " : "",
> +                             type, card->rca);
>        }
>
>  #ifdef CONFIG_DEBUG_FS
> @@ -336,11 +334,10 @@ void mmc_remove_card(struct mmc_card *card)
>
>        if (mmc_card_present(card)) {
>                if (mmc_host_is_spi(card->host)) {
> -                       pr_info("%s: SPI card removed\n",
> -                               mmc_hostname(card->host));
> +                       mmc_host_info(card->host, "SPI card removed\n");
>                } else {
> -                       pr_info("%s: card %04x removed\n",
> -                               mmc_hostname(card->host), card->rca);
> +                       mmc_host_info(card->host, "card %04x removed\n",
> +                                     card->rca);
>                }
>                device_del(&card->dev);
>        }
> diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
> index 39e1311..39779d7 100644
> --- a/drivers/mmc/core/core.c
> +++ b/drivers/mmc/core/core.c
> @@ -155,23 +155,23 @@ void mmc_request_done(struct mmc_host *host, struct mmc_request *mrq)
>
>                led_trigger_event(host->led, LED_OFF);
>
> -               pr_debug("%s: req done (CMD%u): %d: %08x %08x %08x %08x\n",
> -                        mmc_hostname(host), cmd->opcode, err,
> -                        cmd->resp[0], cmd->resp[1],
> -                        cmd->resp[2], cmd->resp[3]);
> +               mmc_host_debug(host, "req done (CMD%u): %d: %08x %08x %08x %08x\n",
> +                              cmd->opcode, err,
> +                              cmd->resp[0], cmd->resp[1],
> +                              cmd->resp[2], cmd->resp[3]);
>
>                if (mrq->data) {
> -                       pr_debug("%s:     %d bytes transferred: %d\n",
> -                                mmc_hostname(host),
> -                                mrq->data->bytes_xfered, mrq->data->error);
> +                       mmc_host_debug(host, "    %d bytes transferred: %d\n",
> +                                      mrq->data->bytes_xfered,
> +                                      mrq->data->error);
>                }
>
>                if (mrq->stop) {
> -                       pr_debug("%s:     (CMD%u): %d: %08x %08x %08x %08x\n",
> -                                mmc_hostname(host), mrq->stop->opcode,
> -                                mrq->stop->error,
> -                                mrq->stop->resp[0], mrq->stop->resp[1],
> -                                mrq->stop->resp[2], mrq->stop->resp[3]);
> +                       mmc_host_debug(host, "    (CMD%u): %d: %08x %08x %08x %08x\n",
> +                                      mrq->stop->opcode,
> +                                      mrq->stop->error,
> +                                      mrq->stop->resp[0], mrq->stop->resp[1],
> +                                      mrq->stop->resp[2], mrq->stop->resp[3]);
>                }
>
>                if (mrq->done)
> @@ -191,22 +191,21 @@ mmc_start_request(struct mmc_host *host, struct mmc_request *mrq)
>        struct scatterlist *sg;
>  #endif
>
> -       pr_debug("%s: starting CMD%u arg %08x flags %08x\n",
> -                mmc_hostname(host), mrq->cmd->opcode,
> -                mrq->cmd->arg, mrq->cmd->flags);
> +       mmc_host_debug(host, "starting CMD%u arg %08x flags %08x\n",
> +                      mrq->cmd->opcode, mrq->cmd->arg, mrq->cmd->flags);
>
>        if (mrq->data) {
> -               pr_debug("%s:     blksz %d blocks %d flags %08x tsac %d ms nsac %d\n",
> -                        mmc_hostname(host), mrq->data->blksz,
> -                        mrq->data->blocks, mrq->data->flags,
> -                        mrq->data->timeout_ns / 1000000,
> -                        mrq->data->timeout_clks);
> +               mmc_host_debug(host, "    blksz %d blocks %d flags %08x tsac %d ms nsac %d\n",
> +                              mrq->data->blksz,
> +                              mrq->data->blocks, mrq->data->flags,
> +                              mrq->data->timeout_ns / 1000000,
> +                              mrq->data->timeout_clks);
>        }
>
>        if (mrq->stop) {
> -               pr_debug("%s:     CMD%u arg %08x flags %08x\n",
> -                        mmc_hostname(host), mrq->stop->opcode,
> -                        mrq->stop->arg, mrq->stop->flags);
> +               mmc_host_debug(host, "    CMD%u arg %08x flags %08x\n",
> +                              mrq->stop->opcode,
> +                              mrq->stop->arg, mrq->stop->flags);
>        }
>
>        WARN_ON(!host->claimed);
> @@ -264,8 +263,8 @@ static void mmc_wait_for_req_done(struct mmc_host *host,
>                if (!cmd->error || !cmd->retries)
>                        break;
>
> -               pr_debug("%s: req failed (CMD%u): %d, retrying...\n",
> -                        mmc_hostname(host), cmd->opcode, cmd->error);
> +               mmc_host_debug(host, "req failed (CMD%u): %d, retrying...\n",
> +                              cmd->opcode, cmd->error);
>                cmd->retries--;
>                cmd->error = 0;
>                host->ops->request(host, mrq);
> @@ -396,14 +395,14 @@ int mmc_interrupt_hpi(struct mmc_card *card)
>        BUG_ON(!card);
>
>        if (!card->ext_csd.hpi_en) {
> -               pr_info("%s: HPI enable bit unset\n", mmc_hostname(card->host));
> +               mmc_host_info(card->host, "HPI enable bit unset\n");
>                return 1;
>        }
>
>        mmc_claim_host(card->host);
>        err = mmc_send_status(card, &status);
>        if (err) {
> -               pr_err("%s: Get card status fail\n", mmc_hostname(card->host));
> +               mmc_host_err(card->host, "Get card status fail\n");
>                goto out;
>        }
>
> @@ -422,15 +421,15 @@ int mmc_interrupt_hpi(struct mmc_card *card)
>                         */
>                        err = mmc_send_hpi_cmd(card, &status);
>                        if (err)
> -                               pr_debug("%s: abort HPI (%d error)\n",
> -                                        mmc_hostname(card->host), err);
> +                               mmc_host_debug(card->host, "abort HPI (%d error)\n",
> +                                              err);
>
>                        err = mmc_send_status(card, &status);
>                        if (err)
>                                break;
>                } while (R1_CURRENT_STATE(status) == R1_STATE_PRG);
>        } else
> -               pr_debug("%s: Left prg-state\n", mmc_hostname(card->host));
> +               mmc_host_debug(card->host, "Left prg-state\n");
>
>  out:
>        mmc_release_host(card->host);
> @@ -620,8 +619,7 @@ int mmc_host_enable(struct mmc_host *host)
>                host->en_dis_recurs = 0;
>
>                if (err) {
> -                       pr_debug("%s: enable error %d\n",
> -                                mmc_hostname(host), err);
> +                       mmc_host_debug(host, "enable error %d\n", err);
>                        return err;
>                }
>        }
> @@ -640,8 +638,7 @@ static int mmc_host_do_disable(struct mmc_host *host, int lazy)
>                host->en_dis_recurs = 0;
>
>                if (err < 0) {
> -                       pr_debug("%s: disable error %d\n",
> -                                mmc_hostname(host), err);
> +                       mmc_host_debug(host, "disable error %d\n", err);
>                        return err;
>                }
>                if (err > 0) {
> @@ -844,10 +841,10 @@ static inline void mmc_set_ios(struct mmc_host *host)
>  {
>        struct mmc_ios *ios = &host->ios;
>
> -       pr_debug("%s: clock %uHz busmode %u powermode %u cs %u Vdd %u width %u timing %u\n",
> -                mmc_hostname(host), ios->clock, ios->bus_mode,
> -                ios->power_mode, ios->chip_select, ios->vdd,
> -                ios->bus_width, ios->timing);
> +       mmc_host_debug(host, "clock %uHz busmode %u powermode %u cs %u Vdd %u width %u timing %u\n",
> +                      ios->clock, ios->bus_mode,
> +                      ios->power_mode, ios->chip_select, ios->vdd,
> +                      ios->bus_width, ios->timing);
>
>        if (ios->clock > 0)
>                mmc_set_ungated(host);
> @@ -1164,8 +1161,7 @@ u32 mmc_select_voltage(struct mmc_host *host, u32 ocr)
>                mmc_set_ios(host);
>                mmc_host_clk_release(host);
>        } else {
> -               pr_warn("%s: host doesn't support card's voltages\n",
> -                       mmc_hostname(host));
> +               mmc_host_warn(host, "host doesn't support card's voltages\n");
>                ocr = 0;
>        }
>
> @@ -1893,8 +1889,8 @@ unsigned int mmc_calc_max_discard(struct mmc_card *card)
>        } else if (max_discard < card->erase_size) {
>                max_discard = 0;
>        }
> -       pr_debug("%s: calculated max. discard sectors %u for timeout %u ms\n",
> -                mmc_hostname(host), max_discard, host->max_discard_to);
> +       mmc_host_debug(host, "calculated max. discard sectors %u for timeout %u ms\n",
> +                      max_discard, host->max_discard_to);
>        return max_discard;
>  }
>  EXPORT_SYMBOL(mmc_calc_max_discard);
> @@ -2006,8 +2002,8 @@ static int mmc_rescan_try_freq(struct mmc_host *host, unsigned freq)
>        host->f_init = freq;
>
>  #ifdef CONFIG_MMC_DEBUG
> -       pr_info("%s: %s: trying to init card at %u Hz\n",
> -               mmc_hostname(host), __func__, host->f_init);
> +       mmc_host_info(host, "%s: trying to init card at %u Hz\n",
> +                     __func__, host->f_init);
>  #endif
>        mmc_power_up(host);
>
> @@ -2142,7 +2138,7 @@ int mmc_power_save_host(struct mmc_host *host)
>        int ret = 0;
>
>  #ifdef CONFIG_MMC_DEBUG
> -       pr_info("%s: %s: powering down\n", mmc_hostname(host), __func__);
> +       mmc_host_info(host, "%s: powering down\n", __func__);
>  #endif
>
>        mmc_bus_get(host);
> @@ -2168,7 +2164,7 @@ int mmc_power_restore_host(struct mmc_host *host)
>        int ret;
>
>  #ifdef CONFIG_MMC_DEBUG
> -       pr_info("%s: %s: powering up\n", mmc_hostname(host), __func__);
> +       mmc_host_info(host, "%s: powering up\n", __func__);
>  #endif
>
>        mmc_bus_get(host);
> @@ -2244,8 +2240,7 @@ int mmc_flush_cache(struct mmc_card *card)
>                err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
>                                EXT_CSD_FLUSH_CACHE, 1, 0);
>                if (err)
> -                       pr_err("%s: cache flush error %d\n",
> -                              mmc_hostname(card->host), err);
> +                       mmc_host_err(card->host, "cache flush error %d\n", err);
>        }
>
>        return err;
> @@ -2274,10 +2269,8 @@ int mmc_cache_ctrl(struct mmc_host *host, u8 enable)
>                        err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
>                                        EXT_CSD_CACHE_CTRL, enable, 0);
>                if (err)
> -                       pr_err("%s: cache %s error %d\n",
> -                              mmc_hostname(card->host),
> -                              enable ? "on" : "off",
> -                              err);
> +                       mmc_host_err(card->host, "cache %s error %d\n",
> +                                    enable ? "on" : "off", err);
>                else
>                        card->ext_csd.cache_ctrl = enable;
>        }
> @@ -2375,8 +2368,8 @@ int mmc_resume_host(struct mmc_host *host)
>                BUG_ON(!host->bus_ops->resume);
>                err = host->bus_ops->resume(host);
>                if (err) {
> -                       pr_warn("%s: error %d during resume (card was removed?)\n",
> -                               mmc_hostname(host), err);
> +                       mmc_host_warn(host, "error %d during resume (card was removed?)\n",
> +                                     err);
>                        err = 0;
>                }
>        }
> diff --git a/drivers/mmc/core/host.c b/drivers/mmc/core/host.c
> index 7f963c0..40d177f 100644
> --- a/drivers/mmc/core/host.c
> +++ b/drivers/mmc/core/host.c
> @@ -75,8 +75,7 @@ static ssize_t clkgate_delay_store(struct device *dev,
>        host->clkgate_delay = value;
>        spin_unlock_irqrestore(&host->clk_lock, flags);
>
> -       pr_info("%s: clock gate delay set to %lu ms\n",
> -                       mmc_hostname(host), value);
> +       mmc_host_info(host, "clock gate delay set to %lu ms\n", value);
>        return count;
>  }
>
> @@ -94,8 +93,7 @@ static void mmc_host_clk_gate_delayed(struct mmc_host *host)
>        unsigned long flags;
>
>        if (!freq) {
> -               pr_debug("%s: frequency set to 0 in disable function, this means the clock is already disabled\n",
> -                        mmc_hostname(host));
> +               mmc_host_debug(host, "frequency set to 0 in disable function, this means the clock is already disabled\n");
>                return;
>        }
>        /*
> @@ -126,7 +124,7 @@ static void mmc_host_clk_gate_delayed(struct mmc_host *host)
>                /* This will set host->ios.clock to 0 */
>                mmc_gate_clock(host);
>                spin_lock_irqsave(&host->clk_lock, flags);
> -               pr_debug("%s: gated MCI clock\n", mmc_hostname(host));
> +               mmc_host_debug(host, "gated MCI clock\n");
>        }
>        spin_unlock_irqrestore(&host->clk_lock, flags);
>        mutex_unlock(&host->clk_gate_mutex);
> @@ -163,7 +161,7 @@ void mmc_host_clk_hold(struct mmc_host *host)
>                spin_unlock_irqrestore(&host->clk_lock, flags);
>                mmc_ungate_clock(host);
>                spin_lock_irqsave(&host->clk_lock, flags);
> -               pr_debug("%s: ungated MCI clock\n", mmc_hostname(host));
> +               mmc_host_debug(host, "ungated MCI clock\n");
>        }
>        host->clk_requests++;
>        spin_unlock_irqrestore(&host->clk_lock, flags);
> @@ -277,8 +275,7 @@ static inline void mmc_host_clk_sysfs_init(struct mmc_host *host)
>        host->clkgate_delay_attr.attr.name = "clkgate_delay";
>        host->clkgate_delay_attr.attr.mode = S_IRUGO | S_IWUSR;
>        if (device_create_file(&host->class_dev, &host->clkgate_delay_attr))
> -               pr_err("%s: Failed to create clkgate_delay sysfs entry\n",
> -                               mmc_hostname(host));
> +               mmc_host_err(host, "Failed to create clkgate_delay sysfs entry\n");
>  }
>  #else
>
> diff --git a/drivers/mmc/core/mmc.c b/drivers/mmc/core/mmc.c
> index f6db788..c7efe5a 100644
> --- a/drivers/mmc/core/mmc.c
> +++ b/drivers/mmc/core/mmc.c
> @@ -102,8 +102,8 @@ static int mmc_decode_cid(struct mmc_card *card)
>                break;
>
>        default:
> -               pr_err("%s: card has unknown MMCA version %d\n",
> -                       mmc_hostname(card->host), card->csd.mmca_vsn);
> +               mmc_host_err(card->host, "card has unknown MMCA version %d\n",
> +                            card->csd.mmca_vsn);
>                return -EINVAL;
>        }
>
> @@ -136,8 +136,8 @@ static int mmc_decode_csd(struct mmc_card *card)
>         */
>        csd->structure = UNSTUFF_BITS(resp, 126, 2);
>        if (csd->structure == 0) {
> -               pr_err("%s: unrecognised CSD structure version %d\n",
> -                       mmc_hostname(card->host), csd->structure);
> +               mmc_host_err(card->host, "unrecognised CSD structure version %d\n",
> +                            csd->structure);
>                return -EINVAL;
>        }
>
> @@ -196,8 +196,7 @@ static int mmc_get_ext_csd(struct mmc_card *card, u8 **new_ext_csd)
>         */
>        ext_csd = kmalloc(512, GFP_KERNEL);
>        if (!ext_csd) {
> -               pr_err("%s: could not allocate a buffer to receive the ext_csd\n",
> -                      mmc_hostname(card->host));
> +               mmc_host_err(card->host, "could not allocate a buffer to receive the ext_csd\n");
>                return -ENOMEM;
>        }
>
> @@ -218,11 +217,9 @@ static int mmc_get_ext_csd(struct mmc_card *card, u8 **new_ext_csd)
>                 * stored in their CSD.
>                 */
>                if (card->csd.capacity == (4096 * 512)) {
> -                       pr_err("%s: unable to read EXT_CSD on a possible high capacity card. Card will be ignored.\n",
> -                              mmc_hostname(card->host));
> +                       mmc_host_err(card->host, "unable to read EXT_CSD on a possible high capacity card. Card will be ignored.\n");
>                } else {
> -                       pr_warn("%s: unable to read EXT_CSD, performance might suffer\n",
> -                               mmc_hostname(card->host));
> +                       mmc_host_warn(card->host, "unable to read EXT_CSD, performance might suffer\n");
>                        err = 0;
>                }
>        } else
> @@ -249,9 +246,8 @@ static int mmc_read_ext_csd(struct mmc_card *card, u8 *ext_csd)
>        card->ext_csd.raw_ext_csd_structure = ext_csd[EXT_CSD_STRUCTURE];
>        if (card->csd.structure == 3) {
>                if (card->ext_csd.raw_ext_csd_structure > 2) {
> -                       pr_err("%s: unrecognised EXT_CSD structure version %d\n",
> -                              mmc_hostname(card->host),
> -                              card->ext_csd.raw_ext_csd_structure);
> +                       mmc_host_err(card->host, "unrecognised EXT_CSD structure version %d\n",
> +                                    card->ext_csd.raw_ext_csd_structure);
>                        err = -EINVAL;
>                        goto out;
>                }
> @@ -259,8 +255,8 @@ static int mmc_read_ext_csd(struct mmc_card *card, u8 *ext_csd)
>
>        card->ext_csd.rev = ext_csd[EXT_CSD_REV];
>        if (card->ext_csd.rev > 6) {
> -               pr_err("%s: unrecognised EXT_CSD revision %d\n",
> -                       mmc_hostname(card->host), card->ext_csd.rev);
> +               mmc_host_err(card->host, "unrecognised EXT_CSD revision %d\n",
> +                            card->ext_csd.rev);
>                err = -EINVAL;
>                goto out;
>        }
> @@ -305,8 +301,7 @@ static int mmc_read_ext_csd(struct mmc_card *card, u8 *ext_csd)
>                break;
>        default:
>                /* MMC v4 spec says this cannot happen */
> -               pr_warn("%s: card is mmc v4 but doesn't support any high-speed modes\n",
> -                       mmc_hostname(card->host));
> +               mmc_host_warn(card->host, "card is mmc v4 but doesn't support any high-speed modes\n");
>        }
>
>        card->ext_csd.raw_s_a_timeout = ext_csd[EXT_CSD_S_A_TIMEOUT];
> @@ -659,8 +654,7 @@ static int mmc_select_powerclass(struct mmc_card *card,
>                        index = EXT_CSD_PWR_CL_200_360;
>                break;
>        default:
> -               pr_warn("%s: Voltage range not supported for power class\n",
> -                       mmc_hostname(host));
> +               mmc_host_warn(host, "Voltage range not supported for power class\n");
>                return -EINVAL;
>        }
>
> @@ -899,8 +893,7 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
>                        goto free_card;
>
>                if (err) {
> -                       pr_warn("%s: switch to highspeed failed\n",
> -                               mmc_hostname(card->host));
> +                       mmc_host_warn(card->host, "switch to highspeed failed\n");
>                        err = 0;
>                } else {
>                        mmc_card_set_highspeed(card);
> @@ -917,8 +910,7 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
>                if (err && err != -EBADMSG)
>                        goto free_card;
>                if (err) {
> -                       pr_warn("%s: Enabling HPI failed\n",
> -                               mmc_hostname(card->host));
> +                       mmc_host_warn(card->host, "Enabling HPI failed\n");
>                        err = 0;
>                } else
>                        card->ext_csd.hpi_en = 1;
> @@ -982,9 +974,8 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
>                        err = mmc_select_powerclass(card, ext_csd_bits[idx][0],
>                                                    ext_csd);
>                        if (err)
> -                               pr_err("%s: power class selection to bus width %d failed\n",
> -                                      mmc_hostname(card->host),
> -                                      1 << bus_width);
> +                               mmc_host_err(card->host, "power class selection to bus width %d failed\n",
> +                                            1 << bus_width);
>
>                        err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
>                                         EXT_CSD_BUS_WIDTH,
> @@ -1012,9 +1003,8 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
>                        err = mmc_select_powerclass(card, ext_csd_bits[idx][1],
>                                                    ext_csd);
>                        if (err)
> -                               pr_err("%s: power class selection to bus width %d ddr %d failed\n",
> -                                      mmc_hostname(card->host),
> -                                      1 << bus_width, ddr);
> +                               mmc_host_err(card->host, "power class selection to bus width %d ddr %d failed\n",
> +                                            1 << bus_width, ddr);
>
>                        err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
>                                         EXT_CSD_BUS_WIDTH,
> @@ -1022,9 +1012,8 @@ static int mmc_init_card(struct mmc_host *host, u32 ocr,
>                                         card->ext_csd.generic_cmd6_time);
>                }
>                if (err) {
> -                       pr_warn("%s: switch to bus width %d ddr %d failed\n",
> -                               mmc_hostname(card->host),
> -                               1 << bus_width, ddr);
> +                       mmc_host_warn(card->host, "switch to bus width %d ddr %d failed\n",
> +                                     1 << bus_width, ddr);
>                        goto free_card;
>                } else if (ddr) {
>                        /*
> @@ -1187,8 +1176,8 @@ static int mmc_sleep(struct mmc_host *host)
>        if (card && card->ext_csd.rev >= 3) {
>                err = mmc_card_sleepawake(host, 1);
>                if (err < 0)
> -                       pr_debug("%s: Error %d while putting card into sleep",
> -                                mmc_hostname(host), err);
> +                       mmc_host_debug(host, "Error %d while putting card into sleep\n",
> +                                      err);
>        }
>
>        return err;
> @@ -1202,8 +1191,8 @@ static int mmc_awake(struct mmc_host *host)
>        if (card && card->ext_csd.rev >= 3) {
>                err = mmc_card_sleepawake(host, 0);
>                if (err < 0)
> -                       pr_debug("%s: Error %d while awaking sleeping card",
> -                                mmc_hostname(host), err);
> +                       mmc_host_debug(host, "Error %d while awaking sleeping card\n",
> +                                      err);
>        }
>
>        return err;
> @@ -1277,8 +1266,7 @@ int mmc_attach_mmc(struct mmc_host *host)
>         * support.
>         */
>        if (ocr & 0x7F) {
> -               pr_warn("%s: card claims to support voltages below the defined range. These will be ignored.\n",
> -                       mmc_hostname(host));
> +               mmc_host_warn(host, "card claims to support voltages below the defined range. These will be ignored.\n");
>                ocr &= ~0x7F;
>        }
>
> @@ -1315,8 +1303,7 @@ remove_card:
>  err:
>        mmc_detach_bus(host);
>
> -       pr_err("%s: error %d whilst initialising MMC card\n",
> -               mmc_hostname(host), err);
> +       mmc_host_err(host, "error %d whilst initialising MMC card\n", err);
>
>        return err;
>  }
> diff --git a/drivers/mmc/core/mmc_ops.c b/drivers/mmc/core/mmc_ops.c
> index 7c7388c..c1e0b9c 100644
> --- a/drivers/mmc/core/mmc_ops.c
> +++ b/drivers/mmc/core/mmc_ops.c
> @@ -415,8 +415,8 @@ int mmc_switch(struct mmc_card *card, u8 set, u8 index, u8 value,
>                        return -EBADMSG;
>        } else {
>                if (status & 0xFDFFA000)
> -                       pr_warn("%s: unexpected status %#x after switch\n",
> -                               mmc_hostname(card->host), status);
> +                       mmc_host_warn(card->host, "unexpected status %#x after switch\n",
> +                                     status);
>                if (status & R1_SWITCH_ERROR)
>                        return -EBADMSG;
>        }
> @@ -477,8 +477,7 @@ mmc_send_bus_test(struct mmc_card *card, struct mmc_host *host, u8 opcode,
>        else if (len == 4)
>                test_buf = testdata_4bit;
>        else {
> -               pr_err("%s: Invalid bus_width %d\n",
> -                      mmc_hostname(host), len);
> +               mmc_host_err(host, "Invalid bus_width %d\n", len);
>                kfree(data_buf);
>                return -EINVAL;
>        }
> @@ -569,8 +568,8 @@ int mmc_send_hpi_cmd(struct mmc_card *card, u32 *status)
>
>        err = mmc_wait_for_cmd(card->host, &cmd, 0);
>        if (err) {
> -               pr_warn("%s: error %d interrupting operation. HPI command response %#x\n",
> -                       mmc_hostname(card->host), err, cmd.resp[0]);
> +               mmc_host_warn(card->host, "error %d interrupting operation. HPI command response %#x\n",
> +                             err, cmd.resp[0]);
>                return err;
>        }
>        if (status)
> diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
> index 1492b7b..2b0fba9 100644
> --- a/drivers/mmc/core/sd.c
> +++ b/drivers/mmc/core/sd.c
> @@ -166,8 +166,8 @@ static int mmc_decode_csd(struct mmc_card *card)
>                csd->erase_size = 1;
>                break;
>        default:
> -               pr_err("%s: unrecognised CSD structure version %d\n",
> -                       mmc_hostname(card->host), csd_struct);
> +               mmc_host_err(card->host, "unrecognised CSD structure version %d\n",
> +                            csd_struct);
>                return -EINVAL;
>        }
>
> @@ -190,8 +190,8 @@ static int mmc_decode_scr(struct mmc_card *card)
>
>        scr_struct = UNSTUFF_BITS(resp, 60, 4);
>        if (scr_struct != 0) {
> -               pr_err("%s: unrecognised SCR structure version %d\n",
> -                       mmc_hostname(card->host), scr_struct);
> +               mmc_host_err(card->host, "unrecognised SCR structure version %d\n",
> +                            scr_struct);
>                return -EINVAL;
>        }
>
> @@ -221,8 +221,7 @@ static int mmc_read_ssr(struct mmc_card *card)
>        u32 *ssr;
>
>        if (!(card->csd.cmdclass & CCC_APP_SPEC)) {
> -               pr_warn("%s: card lacks mandatory SD Status function\n",
> -                       mmc_hostname(card->host));
> +               mmc_host_warn(card->host, "card lacks mandatory SD Status function\n");
>                return 0;
>        }
>
> @@ -232,8 +231,7 @@ static int mmc_read_ssr(struct mmc_card *card)
>
>        err = mmc_app_sd_status(card, ssr);
>        if (err) {
> -               pr_warn("%s: problem reading SD Status register\n",
> -                       mmc_hostname(card->host));
> +               mmc_host_warn(card->host, "problem reading SD Status register\n");
>                err = 0;
>                goto out;
>        }
> @@ -256,8 +254,7 @@ static int mmc_read_ssr(struct mmc_card *card)
>                        card->ssr.erase_offset = eo * 1000;
>                }
>        } else {
> -               pr_warn("%s: SD Status: Invalid Allocation Unit size\n",
> -                       mmc_hostname(card->host));
> +               mmc_host_warn(card->host, "SD Status: Invalid Allocation Unit size\n");
>        }
>  out:
>        kfree(ssr);
> @@ -276,8 +273,7 @@ static int mmc_read_switch(struct mmc_card *card)
>                return 0;
>
>        if (!(card->csd.cmdclass & CCC_SWITCH)) {
> -               pr_warn("%s: card lacks mandatory switch function, performance might suffer\n",
> -                       mmc_hostname(card->host));
> +               mmc_host_warn(card->host, "card lacks mandatory switch function, performance might suffer\n");
>                return 0;
>        }
>
> @@ -285,8 +281,7 @@ static int mmc_read_switch(struct mmc_card *card)
>
>        status = kmalloc(64, GFP_KERNEL);
>        if (!status) {
> -               pr_err("%s: could not allocate a buffer for switch capabilities\n",
> -                      mmc_hostname(card->host));
> +               mmc_host_err(card->host, "could not allocate a buffer for switch capabilities\n");
>                return -ENOMEM;
>        }
>
> @@ -300,8 +295,7 @@ static int mmc_read_switch(struct mmc_card *card)
>                if (err != -EINVAL && err != -ENOSYS && err != -EFAULT)
>                        goto out;
>
> -               pr_warn("%s: problem reading Bus Speed modes\n",
> -                       mmc_hostname(card->host));
> +               mmc_host_warn(card->host, "problem reading Bus Speed modes\n");
>                err = 0;
>
>                goto out;
> @@ -323,8 +317,7 @@ static int mmc_read_switch(struct mmc_card *card)
>                        if (err != -EINVAL && err != -ENOSYS && err != -EFAULT)
>                                goto out;
>
> -                       pr_warn("%s: problem reading Driver Strength\n",
> -                               mmc_hostname(card->host));
> +                       mmc_host_warn(card->host, "problem reading Driver Strength\n");
>                        err = 0;
>
>                        goto out;
> @@ -342,8 +335,7 @@ static int mmc_read_switch(struct mmc_card *card)
>                        if (err != -EINVAL && err != -ENOSYS && err != -EFAULT)
>                                goto out;
>
> -                       pr_warn("%s: problem reading Current Limit\n",
> -                               mmc_hostname(card->host));
> +                       mmc_host_warn(card->host, "problem reading Current Limit\n");
>                        err = 0;
>
>                        goto out;
> @@ -382,8 +374,7 @@ int mmc_sd_switch_hs(struct mmc_card *card)
>
>        status = kmalloc(64, GFP_KERNEL);
>        if (!status) {
> -               pr_err("%s: could not allocate a buffer for switch capabilities\n",
> -                      mmc_hostname(card->host));
> +               mmc_host_err(card->host, "could not allocate a buffer for switch capabilities\n");
>                return -ENOMEM;
>        }
>
> @@ -392,8 +383,7 @@ int mmc_sd_switch_hs(struct mmc_card *card)
>                goto out;
>
>        if ((status[16] & 0xF) != 1) {
> -               pr_warn("%s: problem switching card into high-speed mode!\n",
> -                       mmc_hostname(card->host));
> +               mmc_host_warn(card->host, "problem switching card into high-speed mode!\n");
>                err = 0;
>        } else {
>                err = 1;
> @@ -457,8 +447,7 @@ static int sd_select_driver_type(struct mmc_card *card, u8 *status)
>                return err;
>
>        if ((status[15] & 0xF) != drive_strength) {
> -               pr_warn("%s: problem setting drive strength!\n",
> -                       mmc_hostname(card->host));
> +               mmc_host_warn(card->host, "problem setting drive strength!\n");
>                return 0;
>        }
>
> @@ -536,8 +525,7 @@ static int sd_set_bus_speed_mode(struct mmc_card *card, u8 *status)
>                return err;
>
>        if ((status[16] & 0xF) != card->sd_bus_speed)
> -               pr_warn("%s: problem setting bus speed mode!\n",
> -                       mmc_hostname(card->host));
> +               mmc_host_warn(card->host, "problem setting bus speed mode!\n");
>        else {
>                mmc_set_timing(card->host, timing);
>                mmc_set_clock(card->host, card->sw_caps.uhs_max_dtr);
> @@ -598,8 +586,7 @@ static int sd_set_current_limit(struct mmc_card *card, u8 *status)
>                return err;
>
>        if (((status[15] >> 4) & 0x0F) != current_limit)
> -               pr_warn("%s: problem setting current limit!\n",
> -                       mmc_hostname(card->host));
> +               mmc_host_warn(card->host, "problem setting current limit!\n");
>
>        return 0;
>  }
> @@ -620,8 +607,7 @@ static int mmc_sd_init_uhs_card(struct mmc_card *card)
>
>        status = kmalloc(64, GFP_KERNEL);
>        if (!status) {
> -               pr_err("%s: could not allocate a buffer for switch capabilities\n",
> -                      mmc_hostname(card->host));
> +               mmc_host_err(card->host, "could not allocate a buffer for switch capabilities\n");
>                return -ENOMEM;
>        }
>
> @@ -850,8 +836,7 @@ int mmc_sd_setup_card(struct mmc_host *host, struct mmc_card *card,
>                        ro = host->ops->get_ro(host);
>
>                if (ro < 0) {
> -                       pr_warn("%s: host does not support reading read-only switch. assuming write-enable.\n",
> -                               mmc_hostname(host));
> +                       mmc_host_warn(host, "host does not support reading read-only switch. assuming write-enable.\n");
>                } else if (ro > 0) {
>                        mmc_card_set_readonly(card);
>                }
> @@ -1162,15 +1147,13 @@ int mmc_attach_sd(struct mmc_host *host)
>         * support.
>         */
>        if (ocr & 0x7F) {
> -               pr_warn("%s: card claims to support voltages below the defined range. These will be ignored.\n",
> -                       mmc_hostname(host));
> +               mmc_host_warn(host, "card claims to support voltages below the defined range. These will be ignored.\n");
>                ocr &= ~0x7F;
>        }
>
>        if ((ocr & MMC_VDD_165_195) &&
>            !(host->ocr_avail_sd & MMC_VDD_165_195)) {
> -               pr_warn("%s: SD card claims to support the incompletely defined 'low voltage range'. This will be ignored.\n",
> -                       mmc_hostname(host));
> +               mmc_host_warn(host, "SD card claims to support the incompletely defined 'low voltage range'. This will be ignored.\n");
>                ocr &= ~MMC_VDD_165_195;
>        }
>
> @@ -1207,8 +1190,7 @@ remove_card:
>  err:
>        mmc_detach_bus(host);
>
> -       pr_err("%s: error %d whilst initialising SD card\n",
> -               mmc_hostname(host), err);
> +       mmc_host_err(host, "error %d whilst initialising SD card\n", err);
>
>        return err;
>  }
> diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
> index e994a89..7bae59b 100644
> --- a/drivers/mmc/core/sdio.c
> +++ b/drivers/mmc/core/sdio.c
> @@ -112,8 +112,8 @@ static int sdio_read_cccr(struct mmc_card *card)
>        cccr_vsn = data & 0x0f;
>
>        if (cccr_vsn > SDIO_CCCR_REV_3_00) {
> -               pr_err("%s: unrecognised CCCR structure version %d\n",
> -                       mmc_hostname(card->host), cccr_vsn);
> +               mmc_host_err(card->host, "unrecognised CCCR structure version %d\n",
> +                            cccr_vsn);
>                return -EINVAL;
>        }
>
> @@ -777,8 +777,7 @@ int mmc_attach_sdio(struct mmc_host *host)
>         * support.
>         */
>        if (ocr & 0x7F) {
> -               pr_warn("%s: card claims to support voltages below the defined range. These will be ignored.\n",
> -                       mmc_hostname(host));
> +               mmc_host_warn(host, "card claims to support voltages below the defined range. These will be ignored.\n");
>                ocr &= ~0x7F;
>        }
>
> @@ -873,8 +872,7 @@ remove:
>  err:
>        mmc_detach_bus(host);
>
> -       pr_err("%s: error %d whilst initialising SDIO card\n",
> -               mmc_hostname(host), err);
> +       mmc_host_err(host, "error %d whilst initialising SDIO card\n", err);
>
>        return err;
>  }
> diff --git a/drivers/mmc/core/sdio_cis.c b/drivers/mmc/core/sdio_cis.c
> index 6536fce..e50fecb 100644
> --- a/drivers/mmc/core/sdio_cis.c
> +++ b/drivers/mmc/core/sdio_cis.c
> @@ -132,8 +132,8 @@ static int cis_tpl_parse(struct mmc_card *card, struct sdio_func *func,
>                        ret = -EINVAL;
>                }
>                if (ret && ret != -EILSEQ && ret != -ENOENT) {
> -                       pr_err("%s: bad %s tuple 0x%02x (%u bytes)\n",
> -                              mmc_hostname(card->host), tpl_descr, code, size);
> +                       mmc_host_err(card->host, "bad %s tuple 0x%02x (%u bytes)\n",
> +                                    tpl_descr, code, size);
>                }
>        } else {
>                /* unknown tuple */
> @@ -313,9 +313,8 @@ static int sdio_read_cis(struct mmc_card *card, struct sdio_func *func)
>
>                        if (ret == -ENOENT) {
>                                /* warn about unknown tuples */
> -                               pr_warn("%s: queuing unknown CIS tuple 0x%02x (%u bytes)\n",
> -                                       mmc_hostname(card->host),
> -                                       tpl_code, tpl_link);
> +                               mmc_host_warn(card->host, "queuing unknown CIS tuple 0x%02x (%u bytes)\n",
> +                                             tpl_code, tpl_link);
>                        }
>
>                        /* keep on analyzing tuples */
> diff --git a/drivers/mmc/core/sdio_irq.c b/drivers/mmc/core/sdio_irq.c
> index 533d0e5..3aa13bf 100644
> --- a/drivers/mmc/core/sdio_irq.c
> +++ b/drivers/mmc/core/sdio_irq.c
> @@ -97,8 +97,8 @@ static int sdio_irq_thread(void *_host)
>        period = (host->caps & MMC_CAP_SDIO_IRQ) ?
>                MAX_SCHEDULE_TIMEOUT : idle_period;
>
> -       pr_debug("%s: IRQ thread started (poll period = %lu jiffies)\n",
> -                mmc_hostname(host), period);
> +       mmc_host_debug(host, "IRQ thread started (poll period = %lu jiffies)\n",
> +                      period);
>
>        do {
>                /*
> @@ -157,8 +157,7 @@ static int sdio_irq_thread(void *_host)
>        if (host->caps & MMC_CAP_SDIO_IRQ)
>                host->ops->enable_sdio_irq(host, 0);
>
> -       pr_debug("%s: IRQ thread exiting with code %d\n",
> -                mmc_hostname(host), ret);
> +       mmc_host_debug(host, "IRQ thread exiting with code %d\n", ret);
>
>        return ret;
>  }
> diff --git a/drivers/mmc/host/at91_mci.c b/drivers/mmc/host/at91_mci.c
> index d63f453..4add419 100644
> --- a/drivers/mmc/host/at91_mci.c
> +++ b/drivers/mmc/host/at91_mci.c
> @@ -881,8 +881,8 @@ static irqreturn_t at91_mmc_det_irq(int irq, void *_host)
>         */
>        if (present != host->present) {
>                host->present = present;
> -               pr_debug("%s: card %s\n", mmc_hostname(host->mmc),
> -                       present ? "insert" : "remove");
> +               mmc_host_debug(host->mmc, "card %s\n",
> +                              present ? "insert" : "remove");
>                if (!present) {
>                        pr_debug("****** Resetting SD-card bus width ******\n");
>                        at91_mci_write(host, AT91_MCI_SDCR, at91_mci_read(host, AT91_MCI_SDCR) & ~AT91_MCI_SDCBUS);
> @@ -910,8 +910,9 @@ static void at91_mci_enable_sdio_irq(struct mmc_host *mmc, int enable)
>  {
>        struct at91mci_host *host = mmc_priv(mmc);
>
> -       pr_debug("%s: sdio_irq %c : %s\n", mmc_hostname(host->mmc),
> -               host->board->slot_b ? 'B':'A', enable ? "enable" : "disable");
> +       mmc_host_debug(host->mmc, "sdio_irq %c : %s\n",
> +                      host->board->slot_b ? 'B' : 'A',
> +                      enable ? "enable" : "disable");
>        at91_mci_write(host, enable ? AT91_MCI_IER : AT91_MCI_IDR,
>                host->board->slot_b ? AT91_MCI_SDIOIRQB : AT91_MCI_SDIOIRQA);
>
> diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
> index 5d34c01..b4efd3c 100644
> --- a/drivers/mmc/host/dw_mmc.c
> +++ b/drivers/mmc/host/dw_mmc.c
> @@ -1712,7 +1712,7 @@ static int __init dw_mci_init_slot(struct dw_mci *host, unsigned int id)
>
>        host->vmmc = regulator_get(mmc_dev(mmc), "vmmc");
>        if (IS_ERR(host->vmmc)) {
> -               pr_info("%s: no vmmc regulator found\n", mmc_hostname(mmc));
> +               mmc_host_info(mmc, "no vmmc regulator found\n");
>                host->vmmc = NULL;
>        } else
>                regulator_enable(host->vmmc);
> diff --git a/drivers/mmc/host/msm_sdcc.c b/drivers/mmc/host/msm_sdcc.c
> index 80d8eb1..e0b49ec 100644
> --- a/drivers/mmc/host/msm_sdcc.c
> +++ b/drivers/mmc/host/msm_sdcc.c
> @@ -141,16 +141,15 @@ static void msmsdcc_reset_and_restore(struct msmsdcc_host *host)
>        /* Reset the controller */
>        ret = clk_reset(host->clk, CLK_RESET_ASSERT);
>        if (ret)
> -               pr_err("%s: Clock assert failed at %u Hz with err %d\n",
> -                               mmc_hostname(host->mmc), host->clk_rate, ret);
> +               mmc_host_err(host->mmc, "Clock assert failed at %u Hz with err %d\n",
> +                            host->clk_rate, ret);
>
>        ret = clk_reset(host->clk, CLK_RESET_DEASSERT);
>        if (ret)
> -               pr_err("%s: Clock deassert failed at %u Hz with err %d\n",
> -                               mmc_hostname(host->mmc), host->clk_rate, ret);
> +               mmc_host_err(host->mmc, "Clock deassert failed at %u Hz with err %d\n",
> +                            host->clk_rate, ret);
>
> -       pr_info("%s: Controller has been re-initialiazed\n",
> -                       mmc_hostname(host->mmc));
> +       mmc_host_info(host->mmc, "Controller has been re-initialized\n");
>
>        /* Restore the contoller state */
>        writel(host->pwr, host->base + MMCIPOWER);
> @@ -158,8 +157,8 @@ static void msmsdcc_reset_and_restore(struct msmsdcc_host *host)
>        writel(mci_mask0, host->base + MMCIMASK0);
>        ret = clk_set_rate(host->clk, host->clk_rate);
>        if (ret)
> -               pr_err("%s: Failed to set clk rate %u Hz (%d)\n",
> -                               mmc_hostname(host->mmc), host->clk_rate, ret);
> +               mmc_host_err(host->mmc, "Failed to set clk rate %u Hz (%d)\n",
> +                            host->clk_rate, ret);
>  }
>
>  static void
> @@ -251,11 +250,11 @@ msmsdcc_dma_complete_tlet(unsigned long data)
>        } else {
>                /* Error or flush  */
>                if (host->dma.result & DMOV_RSLT_ERROR)
> -                       pr_err("%s: DMA error (0x%.8x)\n",
> -                              mmc_hostname(host->mmc), host->dma.result);
> +                       mmc_host_err(host->mmc, "DMA error (0x%.8x)\n",
> +                                    host->dma.result);
>                if (host->dma.result & DMOV_RSLT_FLUSH)
> -                       pr_err("%s: DMA channel flushed (0x%.8x)\n",
> -                              mmc_hostname(host->mmc), host->dma.result);
> +                       mmc_host_err(host->mmc, "DMA channel flushed (0x%.8x)\n",
> +                                    host->dma.result);
>
>                pr_err("Flush data: %.8x %.8x %.8x %.8x %.8x %.8x\n",
>                       err.flush[0], err.flush[1], err.flush[2],
> @@ -389,8 +388,7 @@ static int msmsdcc_config_dma(struct msmsdcc_host *host, struct mmc_data *data)
>        n = dma_map_sg(mmc_dev(host->mmc), host->dma.sg,
>                        host->dma.num_ents, host->dma.dir);
>        if (n == 0) {
> -               pr_err("%s: Unable to map in all sg elements\n",
> -                       mmc_hostname(host->mmc));
> +               mmc_host_err(host->mmc, "Unable to map in all sg elements\n");
>                host->dma.sg = NULL;
>                host->dma.num_ents = 0;
>                return -ENOMEM;
> @@ -475,8 +473,7 @@ msmsdcc_start_command_deferred(struct msmsdcc_host *host,
>                *c |= MCI_CSPM_MCIABORT;
>
>        if (host->curr.cmd != NULL) {
> -               pr_err("%s: Overlapping command requests\n",
> -                       mmc_hostname(host->mmc));
> +               mmc_host_err(host->mmc, "Overlapping command requests\n");
>        }
>        host->curr.cmd = cmd;
>  }
> @@ -573,24 +570,23 @@ msmsdcc_data_err(struct msmsdcc_host *host, struct mmc_data *data,
>                 unsigned int status)
>  {
>        if (status & MCI_DATACRCFAIL) {
> -               pr_err("%s: Data CRC error\n", mmc_hostname(host->mmc));
> +               mmc_host_err(host->mmc, "Data CRC error\n");
>                pr_err("%s: opcode 0x%.8x\n", __func__,
>                       data->mrq->cmd->opcode);
>                pr_err("%s: blksz %d, blocks %d\n", __func__,
>                       data->blksz, data->blocks);
>                data->error = -EILSEQ;
>        } else if (status & MCI_DATATIMEOUT) {
> -               pr_err("%s: Data timeout\n", mmc_hostname(host->mmc));
> +               mmc_host_err(host->mmc, "Data timeout\n");
>                data->error = -ETIMEDOUT;
>        } else if (status & MCI_RXOVERRUN) {
> -               pr_err("%s: RX overrun\n", mmc_hostname(host->mmc));
> +               mmc_host_err(host->mmc, "RX overrun\n");
>                data->error = -EIO;
>        } else if (status & MCI_TXUNDERRUN) {
> -               pr_err("%s: TX underrun\n", mmc_hostname(host->mmc));
> +               mmc_host_err(host->mmc, "TX underrun\n");
>                data->error = -EIO;
>        } else {
> -               pr_err("%s: Unknown error (0x%.8x)\n",
> -                      mmc_hostname(host->mmc), status);
> +               mmc_host_err(host->mmc, "Unknown error (0x%.8x)\n", status);
>                data->error = -EIO;
>        }
>  }
> @@ -751,7 +747,7 @@ static void msmsdcc_do_cmdirq(struct msmsdcc_host *host, uint32_t status)
>                cmd->error = -ETIMEDOUT;
>        } else if (status & MCI_CMDCRCFAIL &&
>                   cmd->flags & MMC_RSP_CRC) {
> -               pr_err("%s: Command CRC error\n", mmc_hostname(host->mmc));
> +               mmc_host_err(host->mmc, "Command CRC error\n");
>                cmd->error = -EILSEQ;
>        }
>
> @@ -960,10 +956,9 @@ static void msmsdcc_setup_gpio(struct msmsdcc_host *host, bool enable)
>                        rc = gpio_request(curr->gpio[i].no,
>                                                curr->gpio[i].name);
>                        if (rc) {
> -                               pr_err("%s: gpio_request(%d, %s) failed %d\n",
> -                                       mmc_hostname(host->mmc),
> -                                       curr->gpio[i].no,
> -                                       curr->gpio[i].name, rc);
> +                               mmc_host_err(host->mmc, "gpio_request(%d, %s) failed %d\n",
> +                                            curr->gpio[i].no,
> +                                            curr->gpio[i].name, rc);
>                                goto free_gpios;
>                        }
>                } else {
> @@ -996,8 +991,8 @@ msmsdcc_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
>                if (ios->clock != host->clk_rate) {
>                        rc = clk_set_rate(host->clk, ios->clock);
>                        if (rc < 0)
> -                               pr_err("%s: Error setting clock rate (%d)\n",
> -                                      mmc_hostname(host->mmc), rc);
> +                               mmc_host_err(host->mmc, "Error setting clock rate (%d)\n",
> +                                            rc);
>                        else
>                                host->clk_rate = ios->clock;
>                }
> @@ -1093,8 +1088,8 @@ msmsdcc_check_status(unsigned long data)
>        status = host->plat->status(mmc_dev(host->mmc));
>        host->eject = !status;
>        if (status ^ host->oldstat) {
> -               pr_info("%s: Slot status change detected (%d -> %d)\n",
> -                       mmc_hostname(host->mmc), host->oldstat, status);
> +               mmc_host_info(host->mmc, "Slot status change detected (%d -> %d)\n",
> +                             host->oldstat, status);
>                if (status)
>                        mmc_detect_change(host->mmc, (5 * HZ) / 2);
>                else
> @@ -1123,8 +1118,7 @@ msmsdcc_status_notify_cb(int card_present, void *dev_id)
>  {
>        struct msmsdcc_host *host = dev_id;
>
> -       pr_debug("%s: card_present %d\n", mmc_hostname(host->mmc),
> -              card_present);
> +       mmc_host_debug(host->mmc, "card_present %d\n", card_present);
>        msmsdcc_check_status((unsigned long) host);
>  }
>
> @@ -1321,15 +1315,14 @@ msmsdcc_probe(struct platform_device *pdev)
>                                  DRIVER_NAME " (slot)",
>                                  host);
>                if (ret) {
> -                       pr_err("%s: Unable to get slot IRQ %d (%d)\n",
> -                              mmc_hostname(mmc), host->stat_irq, ret);
> +                       mmc_host_err(mmc, "Unable to get slot IRQ %d (%d)\n",
> +                                    host->stat_irq, ret);
>                        goto clk_disable;
>                }
>        } else if (plat->register_status_notify) {
>                plat->register_status_notify(msmsdcc_status_notify_cb, host);
>        } else if (!plat->status)
> -               pr_err("%s: No card detect facilities available\n",
> -                      mmc_hostname(mmc));
> +               mmc_host_err(mmc, "No card detect facilities available\n");
>        else {
>                init_timer(&host->timer);
>                host->timer.data = (unsigned long)host;
> @@ -1356,28 +1349,26 @@ msmsdcc_probe(struct platform_device *pdev)
>        mmc_set_drvdata(pdev, mmc);
>        mmc_add_host(mmc);
>
> -       pr_info("%s: Qualcomm MSM SDCC at 0x%016llx irq %d,%d dma %d\n",
> -               mmc_hostname(mmc), (unsigned long long)memres->start,
> -               (unsigned int) cmd_irqres->start,
> -               (unsigned int) host->stat_irq, host->dma.channel);
> -       pr_info("%s: 4 bit data mode %s\n", mmc_hostname(mmc),
> -               (mmc->caps & MMC_CAP_4_BIT_DATA ? "enabled" : "disabled"));
> -       pr_info("%s: MMC clock %u -> %u Hz, PCLK %u Hz\n",
> -               mmc_hostname(mmc), msmsdcc_fmin, msmsdcc_fmax, host->pclk_rate);
> -       pr_info("%s: Slot eject status = %d\n", mmc_hostname(mmc), host->eject);
> -       pr_info("%s: Power save feature enable = %d\n",
> -               mmc_hostname(mmc), msmsdcc_pwrsave);
> +       mmc_host_info(mmc, "Qualcomm MSM SDCC at 0x%016llx irq %d,%d dma %d\n",
> +                     (unsigned long long)memres->start,
> +                     (unsigned int) cmd_irqres->start,
> +                     (unsigned int) host->stat_irq, host->dma.channel);
> +       mmc_host_info(mmc, "4 bit data mode %s\n",
> +                     mmc->caps & MMC_CAP_4_BIT_DATA ? "enabled" : "disabled");
> +       mmc_host_info(mmc, "MMC clock %u -> %u Hz, PCLK %u Hz\n",
> +                     msmsdcc_fmin, msmsdcc_fmax, host->pclk_rate);
> +       mmc_host_info(mmc, "Slot eject status = %d\n", host->eject);
> +       mmc_host_info(mmc, "Power save feature enable = %d\n", msmsdcc_pwrsave);
>
>        if (host->dma.channel != -1) {
> -               pr_info("%s: DM non-cached buffer at %p, dma_addr 0x%.8x\n",
> -                       mmc_hostname(mmc), host->dma.nc, host->dma.nc_busaddr);
> -               pr_info("%s: DM cmd busaddr 0x%.8x, cmdptr busaddr 0x%.8x\n",
> -                       mmc_hostname(mmc), host->dma.cmd_busaddr,
> -                       host->dma.cmdptr_busaddr);
> +               mmc_host_info(mmc, "DM non-cached buffer at %p, dma_addr 0x%.8x\n",
> +                             host->dma.nc, host->dma.nc_busaddr);
> +               mmc_host_info(mmc, "DM cmd busaddr 0x%.8x, cmdptr busaddr 0x%.8x\n",
> +                             host->dma.cmd_busaddr, host->dma.cmdptr_busaddr);
>        } else
> -               pr_info("%s: PIO transfer enabled\n", mmc_hostname(mmc));
> +               mmc_host_info(mmc, "PIO transfer enabled\n");
>        if (host->timer.function)
> -               pr_info("%s: Polling status mode enabled\n", mmc_hostname(mmc));
> +               mmc_host_info(mmc, "Polling status mode enabled\n");
>
>        return 0;
>  cmd_irq_free:
> diff --git a/drivers/mmc/host/mvsdio.c b/drivers/mmc/host/mvsdio.c
> index 93012a0..7928e2e 100644
> --- a/drivers/mmc/host/mvsdio.c
> +++ b/drivers/mmc/host/mvsdio.c
> @@ -117,9 +117,8 @@ static int mvsd_setup_data(struct mvsd_host *host, struct mmc_data *data)
>                host->pio_size = data->blocks * data->blksz;
>                host->pio_ptr = sg_virt(data->sg);
>                if (!nodma)
> -                       pr_debug("%s: fallback to PIO for data at 0x%p size %d\n",
> -                                mmc_hostname(host->mmc),
> -                                host->pio_ptr, host->pio_size);
> +                       mmc_host_debug(host->mmc, "fallback to PIO for data at 0x%p size %d\n",
> +                                      host->pio_ptr, host->pio_size);
>                return 1;
>        } else {
>                dma_addr_t phys_addr;
> @@ -470,8 +469,8 @@ static irqreturn_t mvsd_irq(int irq, void *dev)
>                if (mrq->data)
>                        err_status = mvsd_finish_data(host, mrq->data, err_status);
>                if (err_status) {
> -                       pr_err("%s: unhandled error status %#04x\n",
> -                                       mmc_hostname(host->mmc), err_status);
> +                       mmc_host_err(host->mmc, "unhandled error status %#04x\n",
> +                                    err_status);
>                        cmd->error = -ENOMSG;
>                }
>
> @@ -488,9 +487,8 @@ static irqreturn_t mvsd_irq(int irq, void *dev)
>        if (irq_handled)
>                return IRQ_HANDLED;
>
> -       pr_err("%s: unhandled interrupt status=0x%04x en=0x%04x pio=%d\n",
> -              mmc_hostname(host->mmc), intr_status,
> -              host->intr_en, host->pio_size);
> +       mmc_host_err(host->mmc, "unhandled interrupt status=0x%04x en=0x%04x pio=%d\n",
> +                    intr_status, host->intr_en, host->pio_size);
>        return IRQ_NONE;
>  }
>
> @@ -504,13 +502,11 @@ static void mvsd_timeout_timer(unsigned long data)
>        spin_lock_irqsave(&host->lock, flags);
>        mrq = host->mrq;
>        if (mrq) {
> -               pr_err("%s: Timeout waiting for hardware interrupt\n",
> -                      mmc_hostname(host->mmc));
> -               pr_err("%s: hw_state=0x%04x, intr_status=0x%04x intr_en=0x%04x\n",
> -                      mmc_hostname(host->mmc),
> -                      mvsd_read(MVSD_HW_STATE),
> -                      mvsd_read(MVSD_NOR_INTR_STATUS),
> -                      mvsd_read(MVSD_NOR_INTR_EN));
> +               mmc_host_err(host->mmc, "Timeout waiting for hardware interrupt\n");
> +               mmc_host_err(host->mmc, "hw_state=0x%04x, intr_status=0x%04x intr_en=0x%04x\n",
> +                            mvsd_read(MVSD_HW_STATE),
> +                            mvsd_read(MVSD_NOR_INTR_STATUS),
> +                            mvsd_read(MVSD_NOR_INTR_EN));
>
>                host->mrq = NULL;
>
> @@ -801,13 +797,12 @@ static int __init mvsd_probe(struct platform_device *pdev)
>        if (ret)
>                goto out;
>
> -       pr_notice("%s: %s driver initialized, ",
> -                          mmc_hostname(mmc), DRIVER_NAME);
> +       mmc_host_notice(mmc, "%s driver initialized, ", DRIVER_NAME);
>        if (host->gpio_card_detect)
> -               printk("using GPIO %d for card detection\n",
> -                      host->gpio_card_detect);
> +               pr_cont("using GPIO %d for card detection\n",
> +                       host->gpio_card_detect);
>        else
> -               printk("lacking card detect (fall back to polling)\n");
> +               pr_cont("lacking card detect (fall back to polling)\n");
>        return 0;
>
>  out:
> diff --git a/drivers/mmc/host/omap_hsmmc.c b/drivers/mmc/host/omap_hsmmc.c
> index dd5159b..35bddef 100644
> --- a/drivers/mmc/host/omap_hsmmc.c
> +++ b/drivers/mmc/host/omap_hsmmc.c
> @@ -1264,15 +1264,12 @@ static void omap_hsmmc_protect_card(struct omap_hsmmc_host *host)
>        host->reqs_blocked = 0;
>        if (mmc_slot(host).get_cover_state(host->dev, host->slot_id)) {
>                if (host->protect_card) {
> -                       pr_info("%s: cover is closed, card is now accessible\n",
> -                               mmc_hostname(host->mmc));
> +                       mmc_host_info(host->mmc, "cover is closed, card is now accessible\n");
>                        host->protect_card = 0;
>                }
>        } else {
>                if (!host->protect_card) {
> -                       pr_info("%s: cover is open, "
> -                                        "card is now inaccessible\n",
> -                                        mmc_hostname(host->mmc));
> +                       mmc_host_info(host->mmc, "cover is open, card is now inaccessible\n");
>                        host->protect_card = 1;
>                }
>        }
> diff --git a/drivers/mmc/host/pxamci.c b/drivers/mmc/host/pxamci.c
> index fc4356e..f8c6df2 100644
> --- a/drivers/mmc/host/pxamci.c
> +++ b/drivers/mmc/host/pxamci.c
> @@ -558,8 +558,8 @@ static void pxamci_dma_irq(int dma, void *devid)
>        if (dcsr & DCSR_ENDINTR) {
>                writel(BUF_PART_FULL, host->base + MMC_PRTBUF);
>        } else {
> -               pr_err("%s: DMA error on channel %d (DCSR=%#x)\n",
> -                      mmc_hostname(host->mmc), dma, dcsr);
> +               mmc_host_err(host->mmc, "DMA error on channel %d (DCSR=%#x)\n",
> +                            dma, dcsr);
>                host->data->error = -EIO;
>                pxamci_data_done(host, 0);
>        }
> diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
> index d31c31d..3fcf79d 100644
> --- a/drivers/mmc/host/sdhci.c
> +++ b/drivers/mmc/host/sdhci.c
> @@ -202,8 +202,8 @@ static void sdhci_reset(struct sdhci_host *host, u8 mask)
>        /* hw clears the bit when it's done */
>        while (sdhci_readb(host, SDHCI_SOFTWARE_RESET) & mask) {
>                if (timeout == 0) {
> -                       pr_err("%s: Reset 0x%x never completed.\n",
> -                               mmc_hostname(host->mmc), (int)mask);
> +                       mmc_host_err(host->mmc, "Reset 0x%x never completed\n",
> +                                    (int)mask);
>                        sdhci_dumpregs(host);
>                        return;
>                }
> @@ -679,8 +679,8 @@ static u8 sdhci_calc_timeout(struct sdhci_host *host, struct mmc_command *cmd)
>        }
>
>        if (count >= 0xF) {
> -               pr_warn("%s: Too large timeout requested for CMD%d!\n",
> -                       mmc_hostname(host->mmc), cmd->opcode);
> +               mmc_host_warn(host->mmc, "Too large timeout requested for CMD%d!\n",
> +                             cmd->opcode);
>                count = 0xE;
>        }
>
> @@ -972,8 +972,7 @@ static void sdhci_send_command(struct sdhci_host *host, struct mmc_command *cmd)
>
>        while (sdhci_readl(host, SDHCI_PRESENT_STATE) & mask) {
>                if (timeout == 0) {
> -                       pr_err("%s: Controller never released inhibit bit(s)\n",
> -                              mmc_hostname(host->mmc));
> +                       mmc_host_err(host->mmc, "Controller never released inhibit bit(s)\n");
>                        sdhci_dumpregs(host);
>                        cmd->error = -EIO;
>                        tasklet_schedule(&host->finish_tasklet);
> @@ -994,8 +993,7 @@ static void sdhci_send_command(struct sdhci_host *host, struct mmc_command *cmd)
>        sdhci_set_transfer_mode(host, cmd);
>
>        if ((cmd->flags & MMC_RSP_136) && (cmd->flags & MMC_RSP_BUSY)) {
> -               pr_err("%s: Unsupported response type!\n",
> -                       mmc_hostname(host->mmc));
> +               mmc_host_err(host->mmc, "Unsupported response type!\n");
>                cmd->error = -EINVAL;
>                tasklet_schedule(&host->finish_tasklet);
>                return;
> @@ -1154,8 +1152,7 @@ static void sdhci_set_clock(struct sdhci_host *host, unsigned int clock)
>        while (!((clk = sdhci_readw(host, SDHCI_CLOCK_CONTROL))
>                & SDHCI_CLOCK_INT_STABLE)) {
>                if (timeout == 0) {
> -                       pr_err("%s: Internal clock never stabilised\n",
> -                              mmc_hostname(host->mmc));
> +                       mmc_host_err(host->mmc, "Internal clock never stabilised\n");
>                        sdhci_dumpregs(host);
>                        return;
>                }
> @@ -1912,10 +1909,8 @@ static void sdhci_tasklet_card(unsigned long param)
>        /* Check host->mrq first in case we are runtime suspended */
>        if (host->mrq &&
>            !(sdhci_readl(host, SDHCI_PRESENT_STATE) & SDHCI_CARD_PRESENT)) {
> -               pr_err("%s: Card removed during transfer!\n",
> -                       mmc_hostname(host->mmc));
> -               pr_err("%s: Resetting controller.\n",
> -                       mmc_hostname(host->mmc));
> +               mmc_host_err(host->mmc, "Card removed during transfer!\n");
> +               mmc_host_err(host->mmc, "Resetting controller.\n");
>
>                sdhci_reset(host, SDHCI_RESET_CMD);
>                sdhci_reset(host, SDHCI_RESET_DATA);
> @@ -2003,8 +1998,7 @@ static void sdhci_timeout_timer(unsigned long data)
>        spin_lock_irqsave(&host->lock, flags);
>
>        if (host->mrq) {
> -               pr_err("%s: Timeout waiting for hardware interrupt\n",
> -                      mmc_hostname(host->mmc));
> +               mmc_host_err(host->mmc, "Timeout waiting for hardware interrupt\n");
>                sdhci_dumpregs(host);
>
>                if (host->data) {
> @@ -2049,8 +2043,8 @@ static void sdhci_cmd_irq(struct sdhci_host *host, u32 intmask)
>        BUG_ON(intmask == 0);
>
>        if (!host->cmd) {
> -               pr_err("%s: Got command interrupt 0x%08x even though no command operation was in progress\n",
> -                      mmc_hostname(host->mmc), (unsigned)intmask);
> +               mmc_host_err(host->mmc, "Got command interrupt 0x%08x even though no command operation was in progress\n",
> +                            (unsigned)intmask);
>                sdhci_dumpregs(host);
>                return;
>        }
> @@ -2147,8 +2141,8 @@ static void sdhci_data_irq(struct sdhci_host *host, u32 intmask)
>                        }
>                }
>
> -               pr_err("%s: Got data interrupt 0x%08x even though no data operation was in progress\n",
> -                      mmc_hostname(host->mmc), (unsigned)intmask);
> +               mmc_host_err(host->mmc, "Got data interrupt 0x%08x even though no data operation was in progress\n",
> +                            (unsigned)intmask);
>                sdhci_dumpregs(host);
>
>                return;
> @@ -2163,7 +2157,7 @@ static void sdhci_data_irq(struct sdhci_host *host, u32 intmask)
>                        != MMC_BUS_TEST_R)
>                host->data->error = -EILSEQ;
>        else if (intmask & SDHCI_INT_ADMA_ERROR) {
> -               pr_err("%s: ADMA error\n", mmc_hostname(host->mmc));
> +               mmc_host_err(host->mmc, "ADMA error\n");
>                sdhci_show_adma_error(host);
>                host->data->error = -EIO;
>        }
> @@ -2226,8 +2220,7 @@ static irqreturn_t sdhci_irq(int irq, void *dev_id)
>
>        if (host->runtime_suspended) {
>                spin_unlock(&host->lock);
> -               pr_warn("%s: got irq while runtime suspended\n",
> -                       mmc_hostname(host->mmc));
> +               mmc_host_warn(host->mmc, "got irq while runtime suspended\n");
>                return IRQ_HANDLED;
>        }
>
> @@ -2283,8 +2276,7 @@ static irqreturn_t sdhci_irq(int irq, void *dev_id)
>        intmask &= ~SDHCI_INT_ERROR;
>
>        if (intmask & SDHCI_INT_BUS_POWER) {
> -               pr_err("%s: Card is consuming too much power!\n",
> -                       mmc_hostname(host->mmc));
> +               mmc_host_err(host->mmc, "Card is consuming too much power!\n");
>                sdhci_writel(host, SDHCI_INT_BUS_POWER, SDHCI_INT_STATUS);
>        }
>
> @@ -2296,8 +2288,8 @@ static irqreturn_t sdhci_irq(int irq, void *dev_id)
>        intmask &= ~SDHCI_INT_CARD_INT;
>
>        if (intmask) {
> -               pr_err("%s: Unexpected interrupt 0x%08x.\n",
> -                       mmc_hostname(host->mmc), intmask);
> +               mmc_host_err(host->mmc, "Unexpected interrupt 0x%08x\n",
> +                            intmask);
>                sdhci_dumpregs(host);
>
>                sdhci_writel(host, intmask, SDHCI_INT_STATUS);
> @@ -2537,8 +2529,8 @@ int sdhci_add_host(struct sdhci_host *host)
>        host->version = (host->version & SDHCI_SPEC_VER_MASK)
>                                >> SDHCI_SPEC_VER_SHIFT;
>        if (host->version > SDHCI_SPEC_300) {
> -               pr_err("%s: Unknown controller version (%d). You may experience problems.\n",
> -                      mmc_hostname(mmc), host->version);
> +               mmc_host_err(mmc, "Unknown controller version (%d). You may experience problems.\n",
> +                            host->version);
>        }
>
>        caps[0] = (host->quirks & SDHCI_QUIRK_MISSING_CAPS) ? host->caps :
> @@ -2573,8 +2565,7 @@ int sdhci_add_host(struct sdhci_host *host)
>        if (host->flags & (SDHCI_USE_SDMA | SDHCI_USE_ADMA)) {
>                if (host->ops->enable_dma) {
>                        if (host->ops->enable_dma(host)) {
> -                               pr_warn("%s: No suitable DMA available. Falling back to PIO.\n",
> -                                       mmc_hostname(mmc));
> +                               mmc_host_warn(mmc, "No suitable DMA available. Falling back to PIO.\n");
>                                host->flags &=
>                                        ~(SDHCI_USE_SDMA | SDHCI_USE_ADMA);
>                        }
> @@ -2592,8 +2583,7 @@ int sdhci_add_host(struct sdhci_host *host)
>                if (!host->adma_desc || !host->align_buffer) {
>                        kfree(host->adma_desc);
>                        kfree(host->align_buffer);
> -                       pr_warn("%s: Unable to allocate ADMA buffers. Falling back to standard DMA.\n",
> -                               mmc_hostname(mmc));
> +                       mmc_host_warn(mmc, "Unable to allocate ADMA buffers. Falling back to standard DMA.\n");
>                        host->flags &= ~SDHCI_USE_ADMA;
>                }
>        }
> @@ -2619,8 +2609,7 @@ int sdhci_add_host(struct sdhci_host *host)
>        if (host->max_clk == 0 || host->quirks &
>                        SDHCI_QUIRK_CAP_CLOCK_BASE_BROKEN) {
>                if (!host->ops->get_max_clock) {
> -                       pr_err("%s: Hardware doesn't specify base clock frequency\n",
> -                              mmc_hostname(mmc));
> +                       mmc_host_err(mmc, "Hardware doesn't specify base clock frequency\n");
>                        return -ENODEV;
>                }
>                host->max_clk = host->ops->get_max_clock(host);
> @@ -2665,8 +2654,7 @@ int sdhci_add_host(struct sdhci_host *host)
>                        host->timeout_clk = host->ops->get_timeout_clock(host);
>                } else if (!(host->quirks &
>                                SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK)) {
> -                       pr_err("%s: Hardware doesn't specify timeout clock frequency\n",
> -                              mmc_hostname(mmc));
> +                       mmc_host_err(mmc, "Hardware doesn't specify timeout clock frequency\n");
>                        return -ENODEV;
>                }
>        }
> @@ -2833,8 +2821,7 @@ int sdhci_add_host(struct sdhci_host *host)
>                mmc->ocr_avail_mmc &= host->ocr_avail_mmc;
>
>        if (mmc->ocr_avail == 0) {
> -               pr_err("%s: Hardware doesn't report any support voltages\n",
> -                      mmc_hostname(mmc));
> +               mmc_host_err(mmc, "Hardware doesn't report any support voltages\n");
>                return -ENODEV;
>        }
>
> @@ -2881,8 +2868,7 @@ int sdhci_add_host(struct sdhci_host *host)
>                mmc->max_blk_size = (caps[0] & SDHCI_MAX_BLOCK_MASK) >>
>                                SDHCI_MAX_BLOCK_SHIFT;
>                if (mmc->max_blk_size >= 3) {
> -                       pr_warn("%s: Invalid maximum block size, assuming 512 bytes\n",
> -                               mmc_hostname(mmc));
> +                       mmc_host_warn(mmc, "Invalid maximum block size, assuming 512 bytes\n");
>                        mmc->max_blk_size = 0;
>                }
>        }
> @@ -2920,7 +2906,7 @@ int sdhci_add_host(struct sdhci_host *host)
>
>        host->vmmc = regulator_get(mmc_dev(mmc), "vmmc");
>        if (IS_ERR(host->vmmc)) {
> -               pr_info("%s: no vmmc regulator found\n", mmc_hostname(mmc));
> +               mmc_host_info(mmc, "no vmmc regulator found\n");
>                host->vmmc = NULL;
>        } else {
>                regulator_enable(host->vmmc);
> @@ -2949,10 +2935,10 @@ int sdhci_add_host(struct sdhci_host *host)
>
>        mmc_add_host(mmc);
>
> -       pr_info("%s: SDHCI controller on %s [%s] using %s\n",
> -               mmc_hostname(mmc), host->hw_name, dev_name(mmc_dev(mmc)),
> -               (host->flags & SDHCI_USE_ADMA) ? "ADMA" :
> -               (host->flags & SDHCI_USE_SDMA) ? "DMA" : "PIO");
> +       mmc_host_info(mmc, "SDHCI controller on %s [%s] using %s\n",
> +                     host->hw_name, dev_name(mmc_dev(mmc)),
> +                     (host->flags & SDHCI_USE_ADMA) ? "ADMA" :
> +                     (host->flags & SDHCI_USE_SDMA) ? "DMA" : "PIO");
>
>        sdhci_enable_card_detection(host);
>
> @@ -2982,8 +2968,7 @@ void sdhci_remove_host(struct sdhci_host *host, int dead)
>                host->flags |= SDHCI_DEVICE_DEAD;
>
>                if (host->mrq) {
> -                       pr_err("%s: Controller removed during transfer!\n",
> -                              mmc_hostname(host->mmc));
> +                       mmc_host_err(host->mmc, "Controller removed during transfer!\n");
>
>                        host->mrq->cmd->error = -ENOMEDIUM;
>                        tasklet_schedule(&host->finish_tasklet);
> diff --git a/drivers/mmc/host/tmio_mmc.c b/drivers/mmc/host/tmio_mmc.c
> index a4ea102..cfd45cb 100644
> --- a/drivers/mmc/host/tmio_mmc.c
> +++ b/drivers/mmc/host/tmio_mmc.c
> @@ -93,8 +93,8 @@ static int __devinit tmio_mmc_probe(struct platform_device *pdev)
>        if (ret)
>                goto host_remove;
>
> -       pr_info("%s at 0x%08lx irq %d\n", mmc_hostname(host->mmc),
> -               (unsigned long)host->ctl, irq);
> +       mmc_host_info(host->mmc, "at 0x%08lx irq %d\n",
> +                     (unsigned long)host->ctl, irq);
>
>        return 0;
>
> diff --git a/drivers/mmc/host/tmio_mmc_pio.c b/drivers/mmc/host/tmio_mmc_pio.c
> index d85a60c..ad680d7 100644
> --- a/drivers/mmc/host/tmio_mmc_pio.c
> +++ b/drivers/mmc/host/tmio_mmc_pio.c
> @@ -681,8 +681,8 @@ static int tmio_mmc_start_data(struct tmio_mmc_host *host,
>                int blksz_2bytes = pdata->flags & TMIO_MMC_BLKSZ_2BYTES;
>
>                if (data->blksz < 2 || (data->blksz < 4 && !blksz_2bytes)) {
> -                       pr_err("%s: %d byte block unsupported in 4 bit mode\n",
> -                              mmc_hostname(host->mmc), data->blksz);
> +                       mmc_host_err(host->mmc, "%d byte block unsupported in 4 bit mode\n",
> +                                    data->blksz);
>                        return -EINVAL;
>                }
>        }
> diff --git a/drivers/mmc/host/via-sdmmc.c b/drivers/mmc/host/via-sdmmc.c
> index dc479b0..a673161 100644
> --- a/drivers/mmc/host/via-sdmmc.c
> +++ b/drivers/mmc/host/via-sdmmc.c
> @@ -585,7 +585,7 @@ static void via_sdc_send_command(struct via_crdr_mmc_host *host,
>                cmdctrl |= VIA_CRDR_SDCTRL_RSP_R3;
>                break;
>        default:
> -               pr_err("%s: cmd->flag is not valid\n", mmc_hostname(host->mmc));
> +               mmc_host_err(host->mmc, "cmd->flag is not valid\n");
>                break;
>        }
>
> @@ -840,8 +840,8 @@ static void via_sdc_cmd_isr(struct via_crdr_mmc_host *host, u16 intmask)
>        BUG_ON(intmask == 0);
>
>        if (!host->cmd) {
> -               pr_err("%s: Got command interrupt 0x%x even though no command operation was in progress\n",
> -                      mmc_hostname(host->mmc), intmask);
> +               mmc_host_err(host->mmc, "Got command interrupt 0x%x even though no command operation was in progress\n",
> +                            intmask);
>                return;
>        }
>
> @@ -918,8 +918,8 @@ static irqreturn_t via_sdc_isr(int irq, void *dev_id)
>
>        sd_status &= ~(VIA_CRDR_SDSTS_CMD_MASK | VIA_CRDR_SDSTS_DATA_MASK);
>        if (sd_status) {
> -               pr_err("%s: Unexpected interrupt 0x%x\n",
> -                      mmc_hostname(sdhost->mmc), sd_status);
> +               mmc_host_err(sdhost->mmc, "Unexpected interrupt 0x%x\n",
> +                            sd_status);
>                writew(sd_status, addrbase + VIA_CRDR_SDSTATUS);
>        }
>
> @@ -942,9 +942,8 @@ static void via_sdc_timeout(unsigned long ulongdata)
>        spin_lock_irqsave(&sdhost->lock, flags);
>
>        if (sdhost->mrq) {
> -               pr_err("%s: Timeout waiting for hardware interrupt.cmd:0x%x\n",
> -                      mmc_hostname(sdhost->mmc),
> -                      sdhost->mrq->cmd->opcode);
> +               mmc_host_err(sdhost->mmc, "Timeout waiting for hardware interrupt.cmd:0x%x\n",
> +                            sdhost->mrq->cmd->opcode);
>
>                if (sdhost->data) {
>                        writel(VIA_CRDR_DMACTRL_SFTRST,
> @@ -1006,8 +1005,7 @@ static void via_sdc_card_detect(struct work_struct *work)
>        status = readw(addrbase + VIA_CRDR_SDSTATUS);
>        if (!(status & VIA_CRDR_SDSTS_SLOTG)) {
>                if (host->mrq) {
> -                       pr_err("%s: Card removed during transfer!\n",
> -                              mmc_hostname(host->mmc));
> +                       mmc_host_err(host->mmc, "Card removed during transfer!\n");
>                        host->mrq->cmd->error = -ENOMEDIUM;
>                        tasklet_schedule(&host->finish_tasklet);
>                }
> @@ -1192,8 +1190,7 @@ static void __devexit via_sd_remove(struct pci_dev *pcidev)
>        mmiowb();
>
>        if (sdhost->mrq) {
> -               pr_err("%s: Controller removed during transfer\n",
> -                      mmc_hostname(sdhost->mmc));
> +               mmc_host_err(sdhost->mmc, "Controller removed during transfer\n");
>
>                /* make sure all DMA is stopped */
>                writel(VIA_CRDR_DMACTRL_SFTRST,
> diff --git a/drivers/mmc/host/wbsd.c b/drivers/mmc/host/wbsd.c
> index 7536b50..ae474a4 100644
> --- a/drivers/mmc/host/wbsd.c
> +++ b/drivers/mmc/host/wbsd.c
> @@ -194,7 +194,7 @@ static void wbsd_reset(struct wbsd_host *host)
>  {
>        u8 setup;
>
> -       pr_err("%s: Resetting chip\n", mmc_hostname(host->mmc));
> +       mmc_host_err(host->mmc, "Resetting chip\n");
>
>        /*
>         * Soft reset of chip (SD/MMC part).
> @@ -721,8 +721,8 @@ static void wbsd_finish_data(struct wbsd_host *host, struct mmc_data *data)
>                 * Any leftover data?
>                 */
>                if (count) {
> -                       pr_err("%s: Incomplete DMA transfer. %d bytes left.\n",
> -                              mmc_hostname(host->mmc), count);
> +                       mmc_host_err(host->mmc, "Incomplete DMA transfer. %d bytes left.\n",
> +                                    count);
>
>                        if (!data->error)
>                                data->error = -EIO;
> @@ -802,8 +802,8 @@ static void wbsd_request(struct mmc_host *mmc, struct mmc_request *mrq)
>
>                default:
>  #ifdef CONFIG_MMC_DEBUG
> -                       pr_warn("%s: Data command %d is not supported by this controller\n",
> -                               mmc_hostname(host->mmc), cmd->opcode);
> +                       mmc_host_warn(host->mmc, "Data command %d is not supported by this controller\n",
> +                                     cmd->opcode);
>  #endif
>                        cmd->error = -EINVAL;
>
> @@ -1027,8 +1027,7 @@ static void wbsd_tasklet_card(unsigned long param)
>                host->flags &= ~WBSD_FCARD_PRESENT;
>
>                if (host->mrq) {
> -                       pr_err("%s: Card removed during transfer!\n",
> -                               mmc_hostname(host->mmc));
> +                       mmc_host_err(host->mmc, "Card removed during transfer!\n");
>                        wbsd_reset(host);
>
>                        host->mrq->cmd->error = -ENOMEDIUM;
> @@ -1713,17 +1712,17 @@ static int __devinit wbsd_init(struct device *dev, int base, int irq, int dma,
>
>        mmc_add_host(mmc);
>
> -       pr_info("%s: W83L51xD", mmc_hostname(mmc));
> +       mmc_host_info(mmc, "W83L51xD");
>        if (host->chip_id != 0)
> -               printk(" id %x", (int)host->chip_id);
> -       printk(" at 0x%x irq %d", (int)host->base, (int)host->irq);
> +               pr_cont(" id %x", (int)host->chip_id);
> +       pr_cont(" at 0x%x irq %d", (int)host->base, (int)host->irq);
>        if (host->dma >= 0)
> -               printk(" dma %d", (int)host->dma);
> +               pr_cont(" dma %d", (int)host->dma);
>        else
> -               printk(" FIFO");
> +               pr_cont(" FIFO");
>        if (pnp)
> -               printk(" PnP");
> -       printk("\n");
> +               pr_cont(" PnP");
> +       pr_cont("\n");
>
>        return 0;
>  }
> diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
> index 706f722..7483c7e 100644
> --- a/include/linux/mmc/host.h
> +++ b/include/linux/mmc/host.h
> @@ -335,6 +335,17 @@ extern int mmc_add_host(struct mmc_host *);
>  extern void mmc_remove_host(struct mmc_host *);
>  extern void mmc_free_host(struct mmc_host *);
>
> +#define mmc_host_err(mmc, fmt, ...)                            \
> +       pr_err("%s: " fmt, mmc_hostname(mmc), ##__VA_ARGS__)
> +#define mmc_host_warn(mmc, fmt, ...)                           \
> +       pr_warn("%s: " fmt, mmc_hostname(mmc), ##__VA_ARGS__)
> +#define mmc_host_notice(mmc, fmt, ...)                         \
> +       pr_notice("%s: " fmt, mmc_hostname(mmc), ##__VA_ARGS__)
> +#define mmc_host_info(mmc, fmt, ...)                           \
> +       pr_info("%s: " fmt, mmc_hostname(mmc), ##__VA_ARGS__)
> +#define mmc_host_debug(mmc, fmt, ...)                          \
> +       pr_debug("%s: " fmt, mmc_hostname(mmc), ##__VA_ARGS__)
> +
>  static inline void *mmc_priv(struct mmc_host *host)
>  {
>        return (void *)host->private;
> --
> 1.7.6.405.gc1be0
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
